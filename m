Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325C5518B8B
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiECR5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbiECR5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:57:31 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5312BB00
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:53:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id e3so16045133ios.6
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SVhjOiW58CpvHdw8quBjHckuBkf97wIVcsnDQs7q8QU=;
        b=WhnMhXBei59t1jNzijf4GwhnGdkGwN7ffbcmzUwyQYhduCWf8Qeo3tk24P9gnYmmgi
         0HHEZS5CQADa0mC0uxaTLt0esAR/BsI/iTYa5GUg0KlqM6jg6U/Pw3lo40TTPlA6Bdkf
         Wa7bD2wxX0/u5RLDworIKuwVz75s9nO1i4Nzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SVhjOiW58CpvHdw8quBjHckuBkf97wIVcsnDQs7q8QU=;
        b=A9rpbGPH51Qn7MmbuaRwYXsrnodYvgFK9CVDaxDmcl2Q09zKfKZJqvGDcq6eWgsiTq
         siIaxUMumZ4t9b9fR977BEOoCjVuqX5MMkZXMQmhi9R9TLaupgnBPDM8IdB6YrVnTIZ9
         LyKEWRc2rAW0uMWS5dKCsK/fB1ay41gDfQD69EkCdczOSkWQs3k6k3IvpdLGYtxGzB+N
         P6NaU77JAAugXyTbQsgRViTdp3Fyl3OIo9T6C+JCsNZlqX2pjPObAJjDLYz65mG8JDYm
         GB6Ep1mxHdKm7DxPTiGBzVmdCRqnixgjJ2ogaDUbNA+rz5zSJB/YIl444ZynPDXZPqyt
         3xgQ==
X-Gm-Message-State: AOAM533MjrfqSkIKMBA4spSPoG1kRbENEQ+g7voQa11f4myOEukHOFHs
        lwl34pEOLK/ZV/aKgw9Gwkbkqg==
X-Google-Smtp-Source: ABdhPJy0OSUvbC7ByJK8FyKfREM7VamZ4yekW+hdrBnj5rlTwAOTmC0Twkj41WY2MeZnllF6AOEr6Q==
X-Received: by 2002:a05:6638:2588:b0:32a:beec:a5cc with SMTP id s8-20020a056638258800b0032abeeca5ccmr7850035jat.191.1651600437949;
        Tue, 03 May 2022 10:53:57 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:80d8:f53c:c84d:deaa])
        by smtp.gmail.com with ESMTPSA id y4-20020a02ce84000000b0032b3a7817b1sm4055949jaq.117.2022.05.03.10.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:53:57 -0700 (PDT)
Date:   Tue, 3 May 2022 12:53:56 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <YnFsNB9Ppvd0cTFS@do-x1extreme>
References: <20220503174934.2641605-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503174934.2641605-1-sforshee@digitalocean.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 12:49:34PM -0500, Seth Forshee wrote:
> A task can be livepatched only when it is sleeping or it exits to
> userspace. This may happen infrequently for a heavily loaded vCPU task,
> leading to livepatch transition failures.
> 
> Fake signals will be sent to tasks which fail patching via stack
> checking. This will cause running vCPU tasks to exit guest mode, but
> since no signal is pending they return to guest execution without
> exiting to userspace. Fix this by treating a pending livepatch migration
> like a pending signal, exiting to userspace with EINTR. This allows the
> task to be patched, and userspace should re-excecute KVM_RUN to resume
> guest execution.
> 
> In my testing, systems where livepatching would timeout after 60 seconds
> were able to load livepatches within a couple of seconds with this
> change.
> 
> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> ---
> Changes in v2:
>  - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK

Clearly I meant _TIF_PATCH_PENDING here and not _TIF_SIGPENDING.
