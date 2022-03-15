Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A164DA439
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 21:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351743AbiCOUud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 16:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351695AbiCOUuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 16:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B60C62E6B4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 13:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647377358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uH3BgiT40PaIW4EP34mwD8qzGbmoOroMlR0xQ1Dx28Y=;
        b=bjH41A9Nf2AgJ5MpWtCHG1MM0GrDYuEZQ+mtPVH2KQ410t/O9JcjnrXBfJXIUxP8CqPETm
        8/05oZiShIdh2WM2AtEl5mATVLnUzvWRH9neOLyv5kmrixXICEnYPISNp9mdXYtSu/AP65
        FGyO0g+NBX3VqB1sDQ+4NfgGqilYRVI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-gQCKgaMHMKmnPFNk5qL8ZA-1; Tue, 15 Mar 2022 16:49:17 -0400
X-MC-Unique: gQCKgaMHMKmnPFNk5qL8ZA-1
Received: by mail-ej1-f72.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so22890ejk.16
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 13:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uH3BgiT40PaIW4EP34mwD8qzGbmoOroMlR0xQ1Dx28Y=;
        b=uLvejiuBwjf3XQQieGwDsHCbeKPYpuUDLal+0J0APj0upQU9Eze1t/ImY4xMUxg5Kf
         mIoPeDPAEQ92m2ns54ol1pde8vprs1ahs85NkTBHOIc5oxFpH5pcpJCOH93vS2UaAWN9
         1xNCvl+VXJPq+FvWJ4PBca3Z/P/Bcmcfy6PKxbLXMaRmKurMYhB5ucviFq80v85ZIciN
         3dAcRLnCv2Lx8sYklFZYrhT4a6Ls6X73sWvZVpSSkTC6Z54n+HDaGxGpHuzjsy3tdica
         wr7ScUpbgqNQxM9UqXkkR1Yx/g06XpNLm//DedSDwSxE8N4eNq2n9BCQr/jdoIqfOSeI
         3LTA==
X-Gm-Message-State: AOAM530tljrJB5eMEIpZwteRAuG4unLEqTsR3mYzbhUhBOr26azPuGgV
        z10IYBKQdahFLzrECA2516EI0Aa7mUHZ/x4yixisn34YQ48v8ElXCDhs2mS7DdvTNfGMIcmTuGR
        9qzXdH3XWpIuA
X-Received: by 2002:a17:907:3e12:b0:6da:f8d9:efeb with SMTP id hp18-20020a1709073e1200b006daf8d9efebmr24195106ejc.634.1647377356020;
        Tue, 15 Mar 2022 13:49:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztdfhzAIzzKuBiZRLvqH6Mn4J00j5fE+JMlTcZCS2GzE1cpGmijUMK82SHbVvCZjSVrxmhSA==
X-Received: by 2002:a17:907:3e12:b0:6da:f8d9:efeb with SMTP id hp18-20020a1709073e1200b006daf8d9efebmr24195090ejc.634.1647377355723;
        Tue, 15 Mar 2022 13:49:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm30805edb.47.2022.03.15.13.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 13:49:15 -0700 (PDT)
Message-ID: <cb5349be-aced-63e6-6b68-57432c4bd048@redhat.com>
Date:   Tue, 15 Mar 2022 21:49:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND 0/2] KVM: Prevent module exit until all VMs are
 freed
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com
References: <20220303183328.1499189-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220303183328.1499189-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 19:33, David Matlack wrote:
> [Resending with --cc-cover to fix CCs.]
> 
> This series fixes a long-standing theoretical bug where the KVM module
> can be unloaded while there are still references to a struct kvm. This
> can be reproduced with a simple patch [1] to run some delayed work 10
> seconds after a VM file descriptor is released.
> 
> This bug was originally fixed by Ben Gardon <bgardon@google.com> in
> Google's kernel due to a race with an internal kernel daemon.
> 
> KVM's async_pf code looks susceptible to this race since its inception,
> but clearly no one has noticed. Upcoming changes to the TDP MMU will
> move zapping to asynchronous workers which is much more likely to hit
> this issue. Fix it now to close the gap in async_pf and prepare for the
> TDP MMU zapping changes.
> 
> While here I noticed some further cleanups that could be done in the
> async_pf code. It seems unnecessary for the async_pf code to grab a
> reference via kvm_get_kvm() because there's code to synchronously drain
> its queue of work in kvm_destroy_vm() -> ... ->
> kvm_clear_async_pf_completion_queue() (at least on x86). This is
> actually dead code because kvm_destroy_vm() will never be called while
> there are references to kvm.users_count (which the async_pf callbacks
> themselves hold). It seems we could either drop the reference grabbing
> in async_pf.c or drop the call to kvm_clear_async_pf_completion_queue().

Adding a WARN makes sense, but then you'd probably keep the call anyway
just to avoid a use-after-free in case the WARN triggers.

Queued with a note on patch 1:

+	/*
+	 * When the fd passed to this ioctl() is opened it pins the module,
+	 * but try_module_get() also prevents getting a reference if the module
+	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
+	 */

Thanks,

Paolo
> These patches apply on the latest kvm/queue commit b13a3befc815 ("KVM:
> selftests: Add test to populate a VM with the max possible guest mem")
> after reverting commit c9bdd0aa6800 ("KVM: allow struct kvm to outlive
> the file descriptors").

