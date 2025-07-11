Return-Path: <kvm+bounces-52093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA83B01418
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E2C27B71F1
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A811E411C;
	Fri, 11 Jul 2025 07:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBZNiG+t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBD21E32BE
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752217757; cv=none; b=tJZ+VW+jglJGhc5DWm1vKrr12muNK8j9vsJCTY4Md9qq8glVxQknU5d5hipKvO/f1i19u8WLIQaeQcKqmVkWbFjonmIgXrTOHODpqd2OGgOnld6TaHff0SHKbMGIB5cQ83F8YaHz+Br12HNPr9O48fn/kbRcO5xhn4cg0SuyefY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752217757; c=relaxed/simple;
	bh=bETnLwmqaijMFkik+F4Wsz2XGYFd+5UAIq5aNY2jDXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ounU/5+fxFTUV73YpowdzmZgrfdz6kOZmF269MYdJA73O+2rldzcM6uDr3YLFUDIMQctuTPB53B74Yv6nzew2SdSQpuxNEMR5YvDm0D3gy1o66kJjuNpKZhQEsesLq08NouuqZ3UTOwweccyuumKdMAVye+ENmNZgWVxMeycIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBZNiG+t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752217754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tjn8ea09hAYyGZY05rFnfwzbxRm2j2QdgLyEwncWfLM=;
	b=VBZNiG+tOJTORqmU+oeEOUMtoFBDqK/hS3ZXpMR4BMuikR5qEFHCLJ2YoJFUOUEwBkoVrK
	4RIXH3ZJvhorcbNaif+09So4Vna79PmF3emoMQSzEzXpUkeLnIFqRHzyTVlrTdYwY8mEvb
	FXNNBgpvaUBfpjQ2gIIFGI9GHrQIu7w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-FxjyywYePdOV37v_ZPF_1A-1; Fri, 11 Jul 2025 03:09:12 -0400
X-MC-Unique: FxjyywYePdOV37v_ZPF_1A-1
X-Mimecast-MFC-AGG-ID: FxjyywYePdOV37v_ZPF_1A_1752217751
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455e918d690so749415e9.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 00:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752217751; x=1752822551;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tjn8ea09hAYyGZY05rFnfwzbxRm2j2QdgLyEwncWfLM=;
        b=jy2MuBPak78JKq5nBuPQ3L4plmSsL3dx0jTQbK5pU0ZIGmCESIF4dTE2YMk/uGtDrq
         KxVEGnxjcD2/47KBbvzmEFzGCyEJbZq38CQXrOoXqjLI2CvZ80CnWOZpKx2P3yQ1WKJA
         YaYqDrGNw51frsL9Itwvxi3JVFaf12HmNMXIb0QW33fruv6xRVLUsPjBA5g31GRH3rJV
         4R7wK1Wx4vJPchuBT6X3I0GgeFRkHwbBLqj/LdSXZ9IRQUn4ylhSgBjm7nBV1Dqq3Xa5
         SYXSLZKSqozeXehm+qYAOTzehOC3Q+YkDXy1jAyjewami9Zz5c6pLAVnNaXJYzV5i7Nu
         qg3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW9dqKoJlyma1hHAx+Gz1UNPHgx3lqcYZR+3ef4+bBTtCXd54fhPbtaclXLrE0Qwgjbhjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA7xyMB9KgROQxz7O1zlmkJmaGO8qn+vsNzxhSb9cDjHwRpOIF
	lVZhWZB1XoQpTfs/Eg4g8uBdbtqQ3+Nx6xUVoOgxX0MjrqEo7VfUdDqKmoQj9WjmXVyGcOxNFBS
	0BivYqMYr+Nws0am1ESb7wlQVdAjUomFa0b6pu/NGKidnwX78QqBZaw==
X-Gm-Gg: ASbGncuRjjVsjPNovGpEznyY5nnYze9BCcWDsHV3lKIDPtCmuL5LfAx+6tIaTXFng1t
	fvUWVwQPHVpO31WHhUvrQogeZuSaGcgNpJBT5fO1tOjFeDnfR26B6VF4i4ZPlKJ6eJzfzmF5FQw
	4hxyqjbQLkoZ7vkSr5zKt5qWwyxy+zPGyHOX2a3c5QZyfQF2GMM6ubX9H5+zAr9bSHTqtYR7K4e
	2ad61xAefun2JdBYoRwuG3HhkOajjX2awnuNWxjE8xC89x+TpNz66QwqXhH0rpOxw+Z5VLwepGo
	QB+IHgq844iiEu7C0rcud7RsrjRU7a72QZoT6QKuGE7Inp6Jev7PNMpTuZcnZDtNN3W/Q1J/+dj
	q7qcs
X-Received: by 2002:a05:600c:1e02:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-454e2a426afmr18492655e9.0.1752217750983;
        Fri, 11 Jul 2025 00:09:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyLKqZyYTcKdieu4HXWBw9vMWmwczdsUxrQjWlMbBHxItodaJAHPJRLciB88X4EIKhTPKSpQ==
X-Received: by 2002:a05:600c:1e02:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-454e2a426afmr18492375e9.0.1752217750577;
        Fri, 11 Jul 2025 00:09:10 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-115-149.pools.arcor-ip.net. [47.64.115.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454dd4660c5sm38083405e9.11.2025.07.11.00.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 00:09:10 -0700 (PDT)
Message-ID: <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
Date: Fri, 11 Jul 2025 09:09:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Thomas Gleixner <tglx@linutronix.de>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-spdx@vger.kernel.org
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <2025071125-talon-clammy-4971@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/07/2025 07.52, Greg Kroah-Hartman wrote:
> On Fri, Jul 11, 2025 at 07:35:09AM +0200, Thomas Huth wrote:
>> From: Thomas Huth <thuth@redhat.com>
>>
>> The FSF does not reside in the Franklin street anymore. Let's update
>> the address with the link to their website, as suggested in the latest
>> revision of the GPL-2.0 license.
>> (See https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for example)
>>
>> Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   v2: Resend with CC: linux-spdx@vger.kernel.org as suggested here:
>>       https://lore.kernel.org/linuxppc-dev/e5de8010-5663-47f4-a2f0-87fd88230925@csgroup.eu
>>       
>>   arch/powerpc/boot/crtsavres.S            | 5 ++---
>>   arch/powerpc/include/uapi/asm/eeh.h      | 5 ++---
>>   arch/powerpc/include/uapi/asm/kvm.h      | 5 ++---
>>   arch/powerpc/include/uapi/asm/kvm_para.h | 5 ++---
>>   arch/powerpc/include/uapi/asm/ps3fb.h    | 3 +--
>>   arch/powerpc/lib/crtsavres.S             | 5 ++---
>>   arch/powerpc/xmon/ppc.h                  | 5 +++--
>>   7 files changed, 14 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
>> index 085fb2b9a8b89..a710a49a5dbca 100644
>> --- a/arch/powerpc/boot/crtsavres.S
>> +++ b/arch/powerpc/boot/crtsavres.S
>> @@ -26,9 +26,8 @@
>>    * General Public License for more details.
>>    *
>>    * You should have received a copy of the GNU General Public License
>> - * along with this program; see the file COPYING.  If not, write to
>> - * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
>> - * Boston, MA 02110-1301, USA.
>> + * along with this program; see the file COPYING.  If not, see
>> + * <https://www.gnu.org/licenses/>.
>>    *
>>    *    As a special exception, if you link this library with files
>>    *    compiled with GCC to produce an executable, this does not cause
> 
> Please just drop all the "boilerplate" license text from these files,
> and use the proper SPDX line at the top of them instead.  That is the
> overall goal for all kernel files.

Ok, I can do that for the header files ... not quite sure about the *.S 
files though since they contain some additional text about exceptions.
I'll drop those *.S files from the next version of the patch, I think these 
likely need to be discussed separately.

  Thomas


