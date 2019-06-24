Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3BD5100C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfFXPNA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 11:13:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45061 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728417AbfFXPM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jun 2019 11:12:59 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-130-OoVrAoe7MWG74k3yi9X8Ig-1; Mon, 24 Jun 2019 16:12:51 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 24 Jun 2019 16:12:50 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 24 Jun 2019 16:12:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Fenghua Yu' <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v9 03/17] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
Thread-Topic: [PATCH v9 03/17] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Thread-Index: AQHVJihj4k0PM5XU4kKltrhDxHB06Kaq7sOQ
Date:   Mon, 24 Jun 2019 15:12:49 +0000
Message-ID: <746b5a8752cc40b1b954913f786ed9a6@AcuMS.aculab.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-4-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1560897679-228028-4-git-send-email-fenghua.yu@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: OoVrAoe7MWG74k3yi9X8Ig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fenghua Yu
> Sent: 18 June 2019 23:41
> 
> set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
> operate on bitmap defined in x86_capability.
> 
> Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
> the location is at:
> base address of x86_capability + (bit offset in x86_capability / 64) * 8
> 
> Since base address of x86_capability may not be aligned to unsigned long,
> the single unsigned long location may cross two cache lines and
> accessing the location by locked BTS/BTR introductions will cause
> split lock.
> 
> To fix the split lock issue, align x86_capability to size of unsigned long
> so that the location will be always within one cache line.
> 
> Changing x86_capability's type to unsigned long may also fix the issue
> because x86_capability will be naturally aligned to size of unsigned long.
> But this needs additional code changes. So choose the simpler solution
> by setting the array's alignment to size of unsigned long.

As I've pointed out several times before this isn't the only int[] data item
in this code that gets passed to the bit operations.
Just because you haven't got a 'splat' from the others doesn't mean they don't
need fixing at the same time.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/processor.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index c34a35c78618..d3e017723634 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -93,7 +93,9 @@ struct cpuinfo_x86 {
>  	__u32			extended_cpuid_level;
>  	/* Maximum supported CPUID level, -1=no CPUID: */
>  	int			cpuid_level;
> -	__u32			x86_capability[NCAPINTS + NBUGINTS];
> +	/* Aligned to size of unsigned long to avoid split lock in atomic ops */

Wrong comment.
Something like:
	/* Align to sizeof (unsigned long) because the array is passed to the
	 * atomic bit-op functions which require an aligned unsigned long []. */

> +	__u32			x86_capability[NCAPINTS + NBUGINTS]
> +				__aligned(sizeof(unsigned long));

It might be better to use a union (maybe unnamed) here.

>  	char			x86_vendor_id[16];
>  	char			x86_model_id[64];
>  	/* in KB - valid for CPUS which support this call: */
> --
> 2.19.1

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

