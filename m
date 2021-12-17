Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860E479438
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 19:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbhLQSrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 13:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhLQSrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 13:47:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FCC061574;
        Fri, 17 Dec 2021 10:47:39 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639766858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MPUizJvmHOzggChBdmC2cdhx02FOhLObV0ltdfdnzPM=;
        b=Qahv/1IiX+F5lWEIHRnxLL1CR0n+0CVCi5oAumNeETyULgTSNnb7pM33gy8kazFtKMsw10
        QpCijqTu+BCFX2wU6/aWyrjBFrjgtgP28LbLMbwjy4qb4adktMR/Q2HFI/kKtZP1UAvsHj
        iJ8+aQrGHHzhIcYKhCKGYE1uzzUT6C6ymWbE2Nfjx3iGODVt7pd3PKz2cl4u1TeZEHyE51
        0MEB0PeKn5W7aq0VplYXCOw/CaaB8kUJgIPDo22OMtpu5O52I5AGqB2Gas7AIhQGI3RPqc
        1+wetAbicS0e0gsQ4L2IV5dJk2qpcMtuRiW15obq/wi2UshOZgDdhc6+TICdIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639766858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MPUizJvmHOzggChBdmC2cdhx02FOhLObV0ltdfdnzPM=;
        b=T5GwCID3eR4ypf1DTumatjx0bOuxOCtchxRY7wpYIRjaz5k79hieLzPfCh/R4PplnDT7o+
        PX28MWQAgj/l1DDw==
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v2 01/23] x86/fpu: Extend fpu_xstate_prctl() with guest
 permissions
In-Reply-To: <8735mrcbpd.ffs@tglx>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-2-jing2.liu@intel.com> <8735mrcbpd.ffs@tglx>
Date:   Fri, 17 Dec 2021 19:47:37 +0100
Message-ID: <87zgozax12.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17 2021 at 19:45, Thomas Gleixner wrote:

> On Fri, Dec 17 2021 at 07:29, Jing Liu wrote:
>>  
>> -static int __xstate_request_perm(u64 permitted, u64 requested)
>> +static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>>  {
>>  	/*
>>  	 * This deliberately does not exclude !XSAVES as we still might
>> @@ -1605,6 +1605,7 @@ static int __xstate_request_perm(u64 permitted, u64 requested)
>>  	 */
>>  	bool compacted = cpu_feature_enabled(X86_FEATURE_XSAVES);
>>  	struct fpu *fpu = &current->group_leader->thread.fpu;
>> +	struct fpu_state_perm *perm;
>>  	unsigned int ksize, usize;
>>  	u64 mask;
>>  	int ret;
>
> needs to be
>
>       int ret = 0;
>

Alternatively return 0 at the end of the function.
