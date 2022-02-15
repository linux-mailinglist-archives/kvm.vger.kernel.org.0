Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DBC4B77AC
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbiBORM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:12:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiBORM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:12:58 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC13119F59
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:12:47 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id l19so30124384pfu.2
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Ih/L1veWypfxISiZ1TtaNISG3XBd4cm3yr2gMKyACg=;
        b=dYK73zPbAkhTSeb39UbwOGm9YFUDPd0a8aCni9+sVsWlfMzYteao2bcTOyPQkFbN3U
         pXGz6zgGiB4POoy9tgzE3oWFmqLGfVOrNd2qlzb/jaqHHXr/Nzt/d2PVMCYV0r+Zy6Np
         5UiMqJVoXez3TblDAHwYreNkeZ+iPH7tE2we928Z2FHWSJSpMBUWNoneUGPLXXllUxi7
         IY0X0pkOizpQPl8Rn24LIYVzylIjmHNVpDOEVJWw+EIat0xUVdrjzdBNsvfAIiATgC9n
         BYW4C0pQ1+thWhCr6Yj8HCA56AdNcF89uRoujduB9a7HUT3sQi+vDsvfwSnGFG/Z1uL6
         JcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Ih/L1veWypfxISiZ1TtaNISG3XBd4cm3yr2gMKyACg=;
        b=wYwt47/b8ftr7XpZE0V+h4fKa7XRv+69vuq3Xetw0JOU6SQVqhnjeYfUZgzgT5hOyD
         Yym844Qwae00/yW3RXKXaEA453xj8h2FBLkx91ace/hFULOCA55QOjnOIt8PGZvjHENp
         AmaMvmGJ8e3q6/4ky3WGTfhGmO4WgnPYJzv+avE9RzrRIlgWdddy3HRRkrOx0/TVSlik
         9ioo2PtWuMEfg0w35Ew72f6F8kLgyDHuGm5PoL8lEIYw2jvjMUpvQOk0socUcVBXkJ2K
         XOIEpcjAyTAr7ILX4CGLfcsvLdHIm6O7q5o/gp7Je8wTSwPowGSkZhxXpAe8yvJfE/nM
         lo4w==
X-Gm-Message-State: AOAM532toCjljuLKTQOpPFAHoCuSxfOJMxiyTZZNe49PVZHMWg0UCFcv
        sGspBqVxyJY9av+WfUHs11XJnQ==
X-Google-Smtp-Source: ABdhPJyrM4EBr7SfMl20JOUiLnT8F4bn4dyKiGiUdYjgLg/BHgdWuJxRFFxSOIi8z2ZefNOw/Bj8PA==
X-Received: by 2002:aa7:87c7:: with SMTP id i7mr4902382pfo.83.1644945167236;
        Tue, 15 Feb 2022 09:12:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j14sm43340909pfj.218.2022.02.15.09.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 09:12:46 -0800 (PST)
Date:   Tue, 15 Feb 2022 17:12:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/5] KVM: x86: make several APIC virtualization
 callbacks optional
Message-ID: <YgvfC7RGtxJkuOPA@google.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
 <20220214131614.3050333-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131614.3050333-5-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022, Paolo Bonzini wrote:
> SVM does not need most of them, and there's no need for vendors to
> support APIC virtualization to be supported in KVM, so mark them as
> optional and delete the implementation.
> 
> For consistency, apicv_post_state_restore is also marked as optional
> and called with static_call_cond, even though it is implemented for
> both Intel APICv and AMD AVIC.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
