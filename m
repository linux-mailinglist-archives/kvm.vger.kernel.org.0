Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D8615238
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiKATXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKATXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:23:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B091E734
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 12:23:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p21so10617015plr.7
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 12:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LNQwlhlENpZgv8sfso/TY/zz7jFoKJR01U1ZwEI0uOQ=;
        b=M/vKqlOTWO9CVRsj4YgkIdeH1u8N5QF7m30fruLW35nWhTd6ythvm/qdKVBm4LMjxN
         BH6MtUDHDDxSpl4W1bDmuErV6n5gyU6mqRnLzrfvLgn8ijtXX7HUIY/gUjzc8+mg5tai
         1TzmGW00P80uKZi5icpL/dH2V1ubGj74aCO6qlrDFkXq/LjnI5650O1d9VZ0GlpsIwCk
         cC5uT96A/zvR955IbcEeiieX6v6m/gOqogfbQCpYdqDOt05mQeAgeymmXkWICFEx8V43
         mW7BzJU+l5ORb4Tfyno3iUKULva1wsv79D20FTs831RidhCWU+dXINnl+m7zgQ+4BZ1k
         ZMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNQwlhlENpZgv8sfso/TY/zz7jFoKJR01U1ZwEI0uOQ=;
        b=y6Afm/UofT//LFYEB2TsANU7djen+mf++IdHX+9lY2gOK6bsBIA6vRQVzDYVe/Jr6p
         KG6aT3uEvPg66TGa5YaKBBxyWfgeNoSMWAZOZHaYztnyQ87TTqjRoeDi6tk100oPCdPI
         sQzca2CJexyT+Hh/U8RBw02CAYOVkr2XMCuL/kyeV9lPy31EssH6SUopyKJ/EE+qee3E
         rJlcQZcB9qXt4OauFPW1BmUODK9mMGDQyYf+HZI9/24Ma6fcAPjBW6FFJkOXrE4eYcHh
         KO5mT3vbrmm7Z+KGggay7ck5OhHWX2oKAzKpzaUZLF8QDEHjA/EajEusdJB4Fd/7Vi3I
         Y9Lg==
X-Gm-Message-State: ACrzQf1+DbBO1mZYRX6g2OmzDNn+IEXOQKFM/VtYCoZN4a4W4uBTuP2l
        +zfy8+23lDQGNr4W1/qBmOFd1A==
X-Google-Smtp-Source: AMsMyM63XokBADComVqn+D2vm4/2kGQLBnSbAEvqg2iz98WEX9tTOvaJEinCa/p0PLGGXpf4YvaXdw==
X-Received: by 2002:a17:902:ce0f:b0:187:640:42f with SMTP id k15-20020a170902ce0f00b001870640042fmr19641684plg.115.1667330595389;
        Tue, 01 Nov 2022 12:23:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w145-20020a627b97000000b005632f6490aasm6869709pfc.77.2022.11.01.12.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 12:23:15 -0700 (PDT)
Date:   Tue, 1 Nov 2022 19:23:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2 1/2] KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
Message-ID: <Y2FyH9r5Huy3rDao@google.com>
References: <20221019213620.1953281-1-jmattson@google.com>
 <20221019213620.1953281-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019213620.1953281-2-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022, Jim Mattson wrote:
> At this point in time, most guests (in the default, out-of-the-box
> configuration) are likely to use IA32_SPEC_CTRL.  Therefore, drop the
> compiler hint that it is unlikely for KVM to be intercepting WRMSR of
> IA32_SPEC_CTRL.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
