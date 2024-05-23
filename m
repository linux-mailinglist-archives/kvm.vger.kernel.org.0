Return-Path: <kvm+bounces-18027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 812A08CD070
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F0D21F23C25
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85381411CC;
	Thu, 23 May 2024 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DO7urK4D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B4413D523
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716460674; cv=none; b=jK5gEOHa9Up9tY7FrvjW+kBDauo6HahJQ6tKRc5Q0ovKMZ1YWYw7My7yAadArvcDAk2bORZjQdb7sQ0AAfvcT50dRwKzq8jcwkLrKzJ4S2qhFW2eKQJ07qVbfG3BUVq5KT0LDmVbNoc9EgXgaUff3J+BUwpxnDQ4xGatbuph6DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716460674; c=relaxed/simple;
	bh=AwGWt421U9KLZgTiRjEhxg/oYE8y8Lp33lj1qoibEKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kfhwm9Ml4aNyhQ7QnPI93dCOqTQfvqeXMECc6trKH/YL8MozFmaFb6bN5iuAItCfgbMzVJgyoBjgFCxzGipMJDdGpHHt0zwoa7DScVVbBw03AjuxxW+CzqDkofDm4ysHiBZcvKb+oSajLcgD5nVYEoA7+JLyebLZ3FQAcMMETLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DO7urK4D; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a5a2d0d8644so1002799066b.1
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 03:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716460670; x=1717065470; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D0kV23LycN4hVbBu97CSf0VaI8PE3Pmkshp0J0gEaj8=;
        b=DO7urK4DwQ3v8YNMbjJ3fmsL5di7v86W2BNOmE8YwCjFFIrRVeZfwIrigByGc6FhUo
         eL4osXapHZEyskzoVTbp4kcq9zigu6erChQE+50UJSTbzViJEfe5Po87fYaRaH6enLg3
         qoj8I3pM5+6GooEuKgr4Bm24+ujCvDgqGzW/yVBL2fg/BY576vIPS13+hG/MtfLhROgm
         HS5jfRMhShzGi9kPQBvI3f2rGcAvwr1tq6SX349VOn1bpsDWcveZ+xjbTtyWUnChX746
         XrAJV6O5tvWayb2/t1YY8eyKeFHdQ+C2tcAkiowKISloQg1p/LyMK3g5i1yFMvblscVV
         zHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716460670; x=1717065470;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0kV23LycN4hVbBu97CSf0VaI8PE3Pmkshp0J0gEaj8=;
        b=VSVF6DzzvE2TsMFsG41AizZ7nz1akO9rw4i/rZzvZxZCXrxEy1CQC0Ffrj6bgJIR0H
         dAHND1EvMEygqEUcNkFI6o/OlX2JsQGrxwMSH65scJvxIfZagBFO55s6B/2+VhdKVdmw
         oPJPsgITNRYnC3M9T2nMwCzR3+wk0i+0qNOLatJyy4uQzxuMRNMVnC+WEFHSraPT5896
         5mYCGjXuacYxxLb48O4d18ZdQ5gvDpQjFRU5KDcwwy9NlauUAASUQFDrTyfPJBpJ17i+
         9PvaZQGnhgJjCZjBIDJR+jpUtxwafIMpdpmQQEbvjVzBHPh0n6HYvkBFDo9PvqwtrKCu
         +COg==
X-Forwarded-Encrypted: i=1; AJvYcCUiqEYcBJ12AEaZFnTQ4oRGklyEiNC8AdbLCnDNTMRii0VDX3j4/fdvb9JKX9LKFi1XuoTmarLeFM1XzgLRXmEgGF4X
X-Gm-Message-State: AOJu0YxNQHQMVqvH+2JiDceVTaPaQVtW1xFJQZBCQr9d+BQUK847cQb8
	6gJItLPybXhiKjMNvn0HQYgxOAnAtC2T5EbVR49uQZdl85N/zknQW4GBqyy13wY=
X-Google-Smtp-Source: AGHT+IGKpfsQ58eW7UeQwBZqvnYmRvbj2/zaJyvsZpCo+GaTCJyxqPMPM11FmiwsSoF6CsA2OtjG9g==
X-Received: by 2002:a17:906:3b87:b0:a59:c28a:7eb6 with SMTP id a640c23a62f3a-a622805efc9mr323362266b.24.1716460670211;
        Thu, 23 May 2024 03:37:50 -0700 (PDT)
Received: from ?IPV6:2003:e5:8729:4000:29eb:6d9d:3214:39d2? (p200300e58729400029eb6d9d321439d2.dip0.t-ipconnect.de. [2003:e5:8729:4000:29eb:6d9d:3214:39d2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a691870absm1456382566b.124.2024.05.23.03.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 03:37:50 -0700 (PDT)
Message-ID: <23559fcc-97ab-47a2-8832-699c05c4a387@suse.com>
Date: Thu, 23 May 2024 12:37:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
 Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
 <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
 <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>
 <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
 <icnsupynjfh6p7ld7yungwzbplvelfue73ii6m7szezg6ryd46@5owux6sevg2w>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
In-Reply-To: <icnsupynjfh6p7ld7yungwzbplvelfue73ii6m7szezg6ryd46@5owux6sevg2w>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23.05.24 12:35, Kirill A. Shutemov wrote:
> On Fri, May 17, 2024 at 07:25:01PM +0300, Kirill A. Shutemov wrote:
>> On Fri, May 17, 2024 at 05:00:19PM +0200, Jürgen Groß wrote:
>>> On 17.05.24 16:53, Kirill A. Shutemov wrote:
>>>> On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
>>>>> On 17.05.24 16:32, Kirill A. Shutemov wrote:
>>>>>> On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
>>>>>>> @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
>>>>>>>     	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
>>>>>>> +	/*
>>>>>>> +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
>>>>>>> +	 * always work around it.  Query the feature.
>>>>>>> +	 */
>>>>>>> +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
>>>>>>> +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
>>>>>>
>>>>>> I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
>>>>>> be here.
>>>>>
>>>>> No, I don't think so.
>>>>>
>>>>> With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
>>>>> problem in case the seamcall is clobbering it.
>>>>
>>>> Could you check setup_tdparams() in your tree?
>>>>
>>>> Commit
>>>>
>>>> [SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility
>>>>
>>>> in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.
>>>>
>>>> I now remember there was problem in EDK2 using RBP. So the patch is
>>>> temporary until EDK2 is fixed.
>>>>
>>>
>>> I have the following line in setup_tdparams() (not commented out):
>>>
>>> 	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
>>
>> Could you check if it is visible from the guest side?
> 
> Jürgen, have you tried it?
> 

No, I'm not yet at the point where I can boot a guest successfully.


Juergen

