Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CB94C8593
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 08:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiCAHxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 02:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiCAHxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 02:53:36 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8120B4993A;
        Mon, 28 Feb 2022 23:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646121176; x=1677657176;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Vw5wNB9mnCSXJ5OZ/ACGbxYZxQnrMA3CaBRMyS6k+k=;
  b=bkc231YKkPE4fHIp1hYMnFLL0KjsxHkS4ZBIrhkcSHUAt8qYxdI5p9kR
   LDBKBMsDQgeQP/7DW2qNxJmFU863v9eDFfMQC43eqm8aByQc/T09Amvai
   aSGsvWUahsUAaf9PWCHEb4Nc8fz/Y1tCVaR33kFgEtRNkcRAh5Q38wun/
   ZNTKyj8CICjKN7dfUWBKmka4dihjvqbM1xHUlQKlvfrUZWa2LAgkxBdB0
   qN63WWMVJLG2gNKeCou75/wtZny1oH9P/9W8h9YEUtdSacY6FlCciOMzP
   me3AGvrL8TeDPMDFVzpirAkIKAmmFjzrJmmEvhIm6jM73Wqagkp0QLYIB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="233050339"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="233050339"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 23:52:56 -0800
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="550609480"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 23:52:50 -0800
Date:   Tue, 1 Mar 2022 16:03:46 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220301080345.GA31557@gao-cwp>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-7-guang.zeng@intel.com>
 <79f5ce60c65280f4fb7cba0ceedaca0ff5595c48.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79f5ce60c65280f4fb7cba0ceedaca0ff5595c48.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 04:46:31PM +0200, Maxim Levitsky wrote:
>On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
>> From: Maxim Levitsky <mlevitsk@redhat.com>
>> 
>> No normal guest has any reason to change physical APIC IDs, and
>> allowing this introduces bugs into APIC acceleration code.
>> 
>> And Intel recent hardware just ignores writes to APIC_ID in
>> xAPIC mode. More background can be found at:
>> https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
>> 
>> Looks there is no much value to support writable xAPIC ID in
>> guest except supporting some old and crazy use cases which
>> probably would fail on real hardware. So, make xAPIC ID
>> read-only for KVM guests.
>> 
>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>
>Assuming that this is approved and accepted upstream,
>that is even better that my proposal of doing this
>when APICv is enabled.

Sean & Paolo

what's your opinion? Shall we make xAPIC ID read-only unconditionally
or just when enable_apicv is enabled or use a parameter to control
it as Sean suggested at

https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/

Intel SDM Vol3 10.4.6 Local APID ID says:

	In MP systems, the local APIC ID is also used as a processor ID by the
	BIOS and the operating system. Some processors permit software to
	modify the APIC ID. However, the ability of software to modify the APIC
	ID is processor model specific. Because of this, operating system
	software should avoid writing to the local APIC ID register.

So, we think it is fine to make xAPIC ID always read-only. Instead of
supporting writable xAPIC ID in KVM guest, it may be better to fix software
that modify local APIC ID.

Intel IPI virtualization and AVIC are two cases that requires special
handling if xAPIC ID is writable. But it doesn't worth the effort and
is error-prone (e.g., AVIC is broken if guest changed its APIC ID).

>
>Since now apic id is always read only, now we should not 
>forget to clean up some parts of kvm like kvm_recalculate_apic_map,
>which are not needed anymore.

Do you mean marking apic_map as DIRTY isn't needed in some cases?
Or some cleanup should be done inside kvm_recalculate_apic_map()?

For the former, I think we can ...

>
>Best regards,
>	Maxim Levitsky
>
>> ---
>>  arch/x86/kvm/lapic.c | 25 ++++++++++++++++++-------
>>  1 file changed, 18 insertions(+), 7 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index e4bcdab1fac0..b38288c8a94f 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2044,10 +2044,17 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>>  
>>  	switch (reg) {
>>  	case APIC_ID:		/* Local APIC ID */
>> -		if (!apic_x2apic_mode(apic))
>> -			kvm_apic_set_xapic_id(apic, val >> 24);
>> -		else
>> +		if (apic_x2apic_mode(apic)) {
>>  			ret = 1;
>> +			break;
>> +		}
>> +		/* Don't allow changing APIC ID to avoid unexpected issues */
>> +		if ((val >> 24) != apic->vcpu->vcpu_id) {
>> +			kvm_vm_bugged(apic->vcpu->kvm);
>> +			break;
>> +		}
>> +
>> +		kvm_apic_set_xapic_id(apic, val >> 24);

... drop the kvm_apic_set_xapic_id().
