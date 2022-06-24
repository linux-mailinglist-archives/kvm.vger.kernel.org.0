Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F61559540
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiFXIUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiFXIUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:20:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EDB46F492
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656058798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=UGcFf36uwZrCtpOwN7poQ2/boi4OApYDs28q6NEc3euNnIKoVUbE8oAoNOkAbpMSFqKkxI
        W6dk16jn/4UmB5egZLkxsURvghvEEPJEgvR8BzS7C8Ccpta/ePtsIEMfg44Ji7wBdfMx6l
        FuPm3zBBUUacBex/zMqbqeghcViZS9w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-hJDHVbXTO9qmTcgNfHwN0w-1; Fri, 24 Jun 2022 04:19:56 -0400
X-MC-Unique: hJDHVbXTO9qmTcgNfHwN0w-1
Received: by mail-ed1-f71.google.com with SMTP id o11-20020a056402438b00b0043676efd75dso1275222edc.16
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=U3FHmONW3WSczWj5gFDXWAcE5jc7FBe/TZnAvf/kt1P0brg3FcRYq1jUtnU1iCEXjv
         iGcCBWCa2aWV2HVtI951Ma5vXsNUBxeOS8ZEqBAkfbuS3mOmNRDfQu7aGIcaOurjwU+1
         nmJANrk+yOoHjqhzoddJe38ts4wu/3RkJNrtjjoOLuAGqt8XMh2+h5MkzfvMYjdg1yK6
         Ta89UibmbnuEwY92nSG8mvcyhW5FbdK1poQlL0ugGq7F7wLVOSxSgRewZX8197IDcF5a
         ELmUwsJryacfGEVy9BBkmjvttUN7SSK/7k637WOZ4g4RxRXGFp9mFSCO7ZJafIx3dizf
         Eorw==
X-Gm-Message-State: AJIora8hmG1Fm3dUf0mnfvkKvfM88uo1VLNjzO3odRMhiEoJ6SpkQhfu
        Fxr42r8MqYbpKxpJDIRt41g7j4WPqXnJTdui/S+qxBJSGDvUMAcvn10bl3NaCE1uZdGb/epdKpt
        GT6G3UHjiLsg5
X-Received: by 2002:a17:907:7e91:b0:721:9b87:7095 with SMTP id qb17-20020a1709077e9100b007219b877095mr12305419ejc.564.1656058795441;
        Fri, 24 Jun 2022 01:19:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u7+ONMYMtJ3UDi855MyEC8s7LSo/yVsYDkpyEPZmOJ91a8V5amEgrcOsA5l+NGfqWLWF1hvw==
X-Received: by 2002:a17:907:7e91:b0:721:9b87:7095 with SMTP id qb17-20020a1709077e9100b007219b877095mr12305409ejc.564.1656058795236;
        Fri, 24 Jun 2022 01:19:55 -0700 (PDT)
Received: from goa-sendmail ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id kj20-20020a170907765400b00722dac96232sm695084ejc.126.2022.06.24.01.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 01:19:54 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] accel: kvm: Fix memory leak in find_stats_descriptors
Date:   Fri, 24 Jun 2022 10:19:51 +0200
Message-Id: <20220624081952.245740-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624063159.57411-1-linmq006@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

