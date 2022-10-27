Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25F460FF4A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiJ0R1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 13:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiJ0R1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 13:27:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A706718D836
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:27:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id fy4so6659418ejc.5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iKwgc0IEVzdwHiCkgDGhcjbv4ywgJ7EoDsClZ3RBIFQ=;
        b=RbC0vkTGEMUeQrfJXCft2qqEnZJJyBYFBsOMTIEMZCPtrp9s7yI8JISMrDg9xGjgWx
         SaX7Wu/zbIT6zyIEqKxM8HfHRhzrylWfGwazIuBkgyxjTPk5M3xMS5/4ZkCjKwhWFavV
         bXE7tgiBGemndv8v1Dzl99jyPMwtMGt/7j9V3Im3KgeJ9BLkZjGv+hj7t8l6KItdk5tf
         klIYQwrpu2CykpntIeStHWnUW9O1SMhzG5DR8rN2qAz/VacH2qu+ye8MaBXw1Nq2B4hL
         awrIS/shHd1ZNtcEGU2U2bvedTtxv7dAOdLBK6tMVGzGOJKVUB0kLBZDmy/RTo6e+RL5
         FxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iKwgc0IEVzdwHiCkgDGhcjbv4ywgJ7EoDsClZ3RBIFQ=;
        b=MtcD8w8dw39tr4XmwYcHEtLImGqFGb4cagLAo5VLyCyD3l7TEEr8q0SCMKhxCdHP3f
         P7Ojm/W9binDkGRZFEkgKH+koa8L1FGyOTJN71+CgGyfAkgePCCSfq/i256OCawFub+F
         SbdmMK4tKpv1KoIwx8qTZBPSz4gG7K16pbDc8MVSp5AFDvwp92mmfjYMd+phNY1HHwPZ
         ngVpVub7IKiDZS+SR6IEnvr8G82+q00nXmNVqIPS6q3NinIIpDwH+kK6PkX8R034xjW/
         Zcv1Bw5cEFt+lVvNCHP5usy5Fi0c1rT1XxTwz2P2gJKA4v+MBXK1yhtQp17mdQnSoocZ
         6KzQ==
X-Gm-Message-State: ACrzQf2Vx4ubJMm57EYezhB5hmcUpoPircLNwSBvwXQ9I4mttMTA13n8
        O/zCs9fwXBlEmXhdebjGG9Dxku5uMc/QDBToU5Ncq+nZJBk=
X-Google-Smtp-Source: AMsMyM5twZ9tdWk2MZDWI7eWPTemq+JQna3Y1We9BVZLu3UcOLu8pNEbZLf/a6LZBhXDWqj4vAmNIRpWNNqMQPXWjHU=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr43726049ejb.169.1666891640744; Thu, 27
 Oct 2022 10:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221027150558.722062-1-pgonda@google.com> <20221027150558.722062-3-pgonda@google.com>
In-Reply-To: <20221027150558.722062-3-pgonda@google.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 27 Oct 2022 10:27:09 -0700
Message-ID: <CAAH4kHYTYtHBBzF-0BiTzmHHiF=mnQhRy+5Mfsj1WN4vyPoCZg@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] virt: sev: Allow for retrying SNP extended requests
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think just no to this patch? Reasons below.

>
>         if (ghcb->save.sw_exit_info_2) {
> -               /* Number of expected pages are returned in RBX */
> +               /* For a SNP Extended Request, if the request was placed with
> +                * insufficient data pages. The host will return the number of
> +                * pages required using RBX in the GHCB. We can than retry the
> +                * call as an SNP Request to fulfill the command without getting
> +                * the extended request data.
> +                */
>                 if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> -                   ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN)
> -                       input->data_npages = ghcb_get_rbx(ghcb);
> -
> -               *fw_err = ghcb->save.sw_exit_info_2;
> +                   ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN) {
> +                       int npages = ghcb_get_rbx(ghcb);
> +
> +                       ghcb_clear_rax(ghcb);
> +                       ghcb_clear_rbx(ghcb);
> +
> +                       ret = sev_es_ghcb_hv_call(ghcb, &ctxt,
> +                                                 SVM_VMGEXIT_GUEST_REQUEST,
> +                                                 input->req_gpa,
> +                                                 input->resp_gpa);
> +                       if (ret)
> +                               goto e_put;
> +

I'm not keen on reissuing the call in this function. I think
issue_request should do its job of sending a request to the host and
returning the specified data, in this case the number of pages in RBX.
I know it's not particularly fun to interpret exitinfo2 in a couple
places, but it serves a purpose. We don't want this function to grow
to have special cases for all the commands that can be sent to the psp
if they don't involve data passed back through the GHCB. The
get_ghcb/put_ghcb frame is the only thing we really need to respect in
here.

The sev-guest device owns the VMPCKn keys, the message sequence
number, and the responsibility of sending a coherent response back to
user space. When we account for the host changing the certificate page
length during the request and not wanting to return to the guest
without completing the firmware call, the length might grow past the
4KiB max constant we have so far. The driver can make the choice of
issuing the request without extended data like you do here, or to
reallocate its cert_data buffer and ask for the extended data again.
It shouldn't matter to the core functionality of issuing a single
request.

When throttling comes into play and retrying needs to happen more than
once, then we're in another situation where the sev-guest driver also
owns the responsibility of trying not to get throttled too hard. My
patches suggest a 2HZ rate limit to avoid any big penalties of running
requests in a tight loop and looking like a DoS antagonist, but that
doesn't belong in arch/x86/kernel/sev.c due to the variability of
strategies.

> +                       input->data_npages = npages;
> +                       *fw_err = SNP_GUEST_REQ_INVALID_LEN;
> +               } else
> +                       *fw_err = ghcb->save.sw_exit_info_2;

I think in both branches of the conditional, fw_err gets set to
exit_info_2. See v4 of my throttling patch series.

-- 
-Dionna Glaze, PhD (she/her)
