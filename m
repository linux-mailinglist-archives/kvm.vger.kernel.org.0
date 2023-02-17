Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838C169ABDE
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 13:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBQMvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 07:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBQMvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 07:51:24 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E11DC6783F;
        Fri, 17 Feb 2023 04:51:22 -0800 (PST)
Received: from [10.16.224.173] (unknown [167.220.197.45])
        by linux.microsoft.com (Postfix) with ESMTPSA id 02FB52089BF2;
        Fri, 17 Feb 2023 04:51:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02FB52089BF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676638282;
        bh=hzGJwlGScn9yjMqI6ESy0KvfLCFhbdg92VoU9Fu6Q9Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CasyKdtyzd+jS8FrB4Q3wiUwm028Olp65Ifx9ERqZNaukwbfbx9qCv+GhXwXmhd2/
         9M5pMePXWGpftBPg6paI50bDixN3ISl3qpKn2D3chvZzpvSiv2tmkHusFEZNI5IJqj
         dUIbV2xbOCllLKR569/d73B78delC9yGyn2Div14=
Message-ID: <e06d90cc-544b-5280-f8cd-b25684214b4a@linux.microsoft.com>
Date:   Fri, 17 Feb 2023 13:51:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <SA1PR21MB13358707043E2901958819AEBFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <SA1PR21MB13358707043E2901958819AEBFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/02/2023 18:58, Dexuan Cui wrote:
>> From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>> Sent: Thursday, February 16, 2023 1:15 AM
>>> ...
>>> alloc_pgt_page() fails to allocate memory because both
>>> pages->pgt_buf_offset and pages->pgt_buf_size are zero.
>>>
>>>
>>> pgt_data.pgt_buf_size is zero because of this line in
>>> initialize_identity_maps()
>>>      pgt_data.pgt_buf_size = BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
>>>
>>> void initialize_identity_maps(void *rmode)
>>> {
>>> ...
>>>         top_level_pgt = read_cr3_pa();
>>>         if (p4d_offset((pgd_t *)top_level_pgt, 0) == (p4d_t *)_pgtable) {
>>>                 pgt_data.pgt_buf = _pgtable + BOOT_INIT_PGT_SIZE;
>>>                 pgt_data.pgt_buf_size = BOOT_PGT_SIZE -
>>> BOOT_INIT_PGT_SIZE;
>>>                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
>>>         } else {
>>>                 pgt_data.pgt_buf = _pgtable;
>>>                 pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
>>>                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
>>>                 top_level_pgt = (unsigned
>>> long)alloc_pgt_page(&pgt_data);
>>
>> I just tested an SNP guest on KVM with and without
>> CONFIG_RANDOMIZE_BASE.
>> In both cases we end up in the else() branch.
>> With CONFIG_RANDOMIZE_BASE BOOT_PGT_SIZE=0x13000
>> Without CONFIG_RANDOMMIZE_BASE BOOT_PGT_SIZE=0x6000.
>>
>> So in both cases pgt_data.pgt_buf_size != 0.
>>
>> Getting into that first branch would require having 5-level paging supported
>> (CONFIG_X86_5LEVEL=y) and enabled inside the guest, I don't have that on
>> any
>> hardware I have access to.
>>
>> Jeremi
> 
> CONFIG_X86_5LEVEL is not set for my kernel.
> 
> The comment before the first branch says:
>   On 4-level paging, p4d_offset(top_level_pgt, 0) is equal to 'top_level_pgt'.
> 
> IIUC this means 'top_level_pgt' is equal to '_pgtable'? i.e. without 
> CONFIG_RANDOMIZE_BASE, pgt_data.pgt_buf_size should be 0.
> 
> Not sure why it's not getting into the first branch for you.

Sorry, I got two things confused here. The relevant part of the comment is this:
"If we came here via startup_32(), cr3 will be _pgtable already".

Booting a (non-SNP) guest via BIOS I end up in the first branch. Upstream SNP support
requires OVMF (UEFI) so we'll always reach the kernel in 64-bit mode (startup_64?),
and end up in the second branch.

Jeremi
