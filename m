Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C5C59C574
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbiHVRwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiHVRwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:52:38 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480131DC6
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:52:35 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u14so13105455oie.2
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=U2h5OXIBtshmMp3mHspaMeSDYtMFmp6iDWsUHs1xsvE=;
        b=DPE70e9T2KhFYle8ZEtERFl+OtAzDLlj7JzEHgoh+udL+iBNNhw+/09fRAyhoaK8Sq
         Atnb0PglyST4kowizHMLWZapRO8ixt5dvKZkpIoQrlmlIejPxAikNZx8sEOafM4ZHwMr
         wqm9lbxm1EMEJZWqVkZGVNbAw3oLdjJte637zPgr/EibG4hs9MDa09zpewKgMTTwX9tD
         GfukNr/sgUnsFKK36mszlgRh29Z7twjQRUaGwlQRCmY3/wKWWOz4nKwKhqcbOJXS2f4K
         +8Fkg80/Epe6tfYySghxpUA9guu4MLbDAy1c3q9ueOqG27DrgPRD0gxThAjgY5ZfJNHB
         J8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=U2h5OXIBtshmMp3mHspaMeSDYtMFmp6iDWsUHs1xsvE=;
        b=3VgZEYPM/NDRm5dACJ06chGQNdWUpAo0u4JxJZWSb1p6m/QrY+bPUMp37tqEH4a3Vq
         utlNpy7ZOjqcW2XnR+wk3qJGoU6a3ER2oc2rlXeCoKr7Ni8n6i/pMfCObEt53bzntDxG
         TtGWkvTPXYcBeBaCmPv2yH+qzLYm4OcH+vk3AJ+/Kbv5U2wmR6md94C9q/pT2wsL91Ij
         ExLVul7CrXyQFhPBDC5qm0MQa+t8kr961E9I6fiBfKHmrCTBciqG7lgu7fk4L6tfLbG+
         1F6WXNi3UMj3Ty0fjs8kcanvtK8eAjG8M871vsqxDnpPxLb65goWYAcM6vxChMPcsSC6
         CLGw==
X-Gm-Message-State: ACgBeo3gxK170d8p5dEopckinsZtDun3o/4kdnkGfi7I3O/tLAUYwtHT
        tYKuZ0auGg+c1xI8PkaB15/MwQ9i5//Eh/XuxWtfLg==
X-Google-Smtp-Source: AA6agR79ebV5129RKavswXPVJ+9jQjtHbNqi7U32f7bcfK5zHIBh170ynXk7u8oGwLYI2TrCnHetzVwH+oC9/CUzayw=
X-Received: by 2002:aca:170f:0:b0:343:171f:3596 with SMTP id
 j15-20020aca170f000000b00343171f3596mr9159402oii.181.1661190753993; Mon, 22
 Aug 2022 10:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220822170659.2527086-1-pbonzini@redhat.com> <20220822170659.2527086-4-pbonzini@redhat.com>
In-Reply-To: <20220822170659.2527086-4-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 22 Aug 2022 10:52:23 -0700
Message-ID: <CALMp9eRaTV+B6+SA0ecwi6u6KfNyVX33VToYQe-A5ovS=UAwUg@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] KVM: nVMX: Make an event request when pending an
 MTF nested VM-Exit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022 at 10:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
> through inject_pending_event() and thus vmx_check_nested_events() prior
> to re-entering the guest.
>
> MTF currently works by virtue of KVM's hack that calls
> kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
> be removed in the near future.  Until that call is removed, the patch
> introduces no functional change.
>
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
What happens if live migration occurs before the KVM_REQ_EVENT is processed?
