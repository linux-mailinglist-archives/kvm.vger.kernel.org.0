Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B06BA2AA
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 23:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjCNWod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 18:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCNWoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 18:44:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA3A27D45
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 15:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678833825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nHo/YNV6RCtVFeo660OXEQBt9GzPcSGMqLy290S1DfY=;
        b=CSvsCmDiPJlEwIZ+IikKTlO1h9CWBKxHPjRXYp45i+bXnKsAOpN3HtXct4q5JTt/mm0F2G
        S+MfefO2i3l5Qrn5svgrSD856lGGxBdbZwFM4/Y6fnSZI5CmfmDMmDkZrxheRRuL1G3wtD
        iJaIru9zVNTjZVWA9tHWr1ntO5ToLow=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-eiPVbDMHNMqwSwa0cqSGTg-1; Tue, 14 Mar 2023 18:43:43 -0400
X-MC-Unique: eiPVbDMHNMqwSwa0cqSGTg-1
Received: by mail-vs1-f72.google.com with SMTP id p27-20020a05610223fb00b00425b0a40455so976295vsc.8
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 15:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678833822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHo/YNV6RCtVFeo660OXEQBt9GzPcSGMqLy290S1DfY=;
        b=3AELgZgMaXVhpzfSJw+wM0IkoskJeM+0dbETnBCzCUvnHsWWx45n9TkVIMRFpGTTXd
         1HcAJoozEl5raGbXJVNIsLj0YqJ1CbUWQTXyDl/p6851TaD6mPf4MeLkB3VjC82lyKEr
         Cf+CL5I6jArTGlETvmeB7gWks80VTkiTWDK9WRsY5z+TW/pNehEy4XzlUyMzEEb4U40K
         FH0fjIhRKZTsBQWWrPFF7biGfbijjC6Gmr205jcM231P8QYhE/BxIGaWwmdyPF8k3V+p
         07I0hnbH+wkND2Si6Z76QzXaDDcYaAP8jH9zTbQreqt77jOMeDWXE32df81Qnna5aL32
         WMkQ==
X-Gm-Message-State: AO0yUKV8P0CaMyPpzDWoRFJOChs/RWvtJdzKskjICFvn1CWuSbNUcgMH
        dkzITTsRdUoAuJqhtfPhR3aZUA5EtrxYuNVEeWVHS3GU8neI1E/EsGF26FytPbTYSohfZaLkccZ
        dZYSZ0SJGRII5RVcZfrkZtiTkBE3cOlKg9oKr
X-Received: by 2002:a9f:3149:0:b0:68b:9eed:1c7d with SMTP id n9-20020a9f3149000000b0068b9eed1c7dmr24409518uab.0.1678833822695;
        Tue, 14 Mar 2023 15:43:42 -0700 (PDT)
X-Google-Smtp-Source: AK7set9/A++8n7MyHFqV21Qt1JAMsKJ3IBkeMZaZUquJVCzT9ql9AX6/8jWlF683ZJvDJg3NRIP4jvkGyKxRNp9LdWM=
X-Received: by 2002:a9f:3149:0:b0:68b:9eed:1c7d with SMTP id
 n9-20020a9f3149000000b0068b9eed1c7dmr24409507uab.0.1678833822437; Tue, 14 Mar
 2023 15:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230211003534.564198-1-seanjc@google.com> <20230314134356.3053443-1-pbonzini@redhat.com>
 <ZBCEphyd205U4gxF@google.com>
In-Reply-To: <ZBCEphyd205U4gxF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 14 Mar 2023 23:43:30 +0100
Message-ID: <CABgObfZoQAis56NaVO0Pi6U_BsY3_Ue41mOJGQtXTWex2D2Wpg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Stub out enable_evmcs static key
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Il mar 14 mar 2023, 15:29 Sean Christopherson <seanjc@google.com> ha scritto:
>
> On Tue, Mar 14, 2023, Paolo Bonzini wrote:
> > Queued, thanks.
>
> Paolo,
>
> Are you grabbing this for 6.3 or 6.4?  If it's for 6.4, what is your plan for 6.4?
> I assumed we were taking the same approach as we did for 6.3, where you handle the
> current cycle (stabilizing 6.3) and I focus on the next cycle (building 6.4).


This one is for 6.4. What we did for 6.3 included me merging a handful
of series that were not included in the previous merge window; so
that's what I did today. If that's okay for you, once the -rc3 pull
request is sent (probably tomorrow) I will push to kvm/next and that
will be it.

I do plan to review a few other outstanding series of yours,
especially the MSRs and the reboot ones.

Paolo

