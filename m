Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761C7479431
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 19:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbhLQSpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 13:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbhLQSpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 13:45:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB42BC061574;
        Fri, 17 Dec 2021 10:45:21 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639766719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NdAfZf/L+/cLx1BjJZHWLWYxnHLFGFuBWqvoVtBNLj8=;
        b=iatmu9jrjIgBIJBQmnbTu4fkwbPnxl+JGNSOmM2yUrsZdxMYoGJ9/ulM8jdBcUTaNjfd5I
        iTh5iTWQ/VYKin+ByDelgNqr16MXZyrn85unyDPEkEFfgleuxDmy17JeFInfYVJ9lKRsaw
        IZ1In06yVTW0qXe2eEaQT0akjUFfyLDwHosQ+SHuwKlsbTmrjouQP7rjQlP0SjZwxSlfgD
        3qiTbI/gKviUDbRwFkGfQNzbQu5/SGc+x4FAGNNn76LuoBgYa9xT5YB4WklIlS50lxK341
        tCrewVq2y8HIxuHwvOtSG2xZvrAlowRSjCkpLddbHQ80YfkQLbgLjh8jspt6RQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639766719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NdAfZf/L+/cLx1BjJZHWLWYxnHLFGFuBWqvoVtBNLj8=;
        b=X+T0Orr6Db0XVlHQJibHIWU8OmP5sdmv5BV3c4ITUqUfO9sfpwZm/M6V3VfoJQ6AF4HZXm
        uv2pxCMMBnKdInDg==
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v2 01/23] x86/fpu: Extend fpu_xstate_prctl() with guest
 permissions
In-Reply-To: <20211217153003.1719189-2-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-2-jing2.liu@intel.com>
Date:   Fri, 17 Dec 2021 19:45:18 +0100
Message-ID: <8735mrcbpd.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17 2021 at 07:29, Jing Liu wrote:
>  
> -static int __xstate_request_perm(u64 permitted, u64 requested)
> +static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>  {
>  	/*
>  	 * This deliberately does not exclude !XSAVES as we still might
> @@ -1605,6 +1605,7 @@ static int __xstate_request_perm(u64 permitted, u64 requested)
>  	 */
>  	bool compacted = cpu_feature_enabled(X86_FEATURE_XSAVES);
>  	struct fpu *fpu = &current->group_leader->thread.fpu;
> +	struct fpu_state_perm *perm;
>  	unsigned int ksize, usize;
>  	u64 mask;
>  	int ret;

needs to be

      int ret = 0;

Do not blindly copy code from that Gleixner dude...

Thanks,

        tglx
