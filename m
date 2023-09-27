Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE07B013A
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 12:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjI0KFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 06:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjI0KFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 06:05:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A7EB
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 03:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695809062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=YXBNjXlXpPZLQYGNCeV+d0GTmVFb7O3FGlG9CRd7j9edQMOfhnN1tUyptoM9A96WchvBC8
        iNMxnra/7onkOYVhwniVbSte/kQ0CXC//CjHCsk32zUC3obYB//yMNFzOxpiDGuvS2PAEG
        JvRz1YcjO0Bg1Ms102b+sV29Di1QAgU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-yJHkIz0WNLS50cJlFBlFnQ-1; Wed, 27 Sep 2023 06:04:20 -0400
X-MC-Unique: yJHkIz0WNLS50cJlFBlFnQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ae57d8b502so892518866b.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 03:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695809059; x=1696413859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Uo8IIanRKwEnQ2bJLE1xJEzJq9hgd/apfRRRZQG3WOjPSprt8arOdD9SeEi1qSvxR8
         gOpVql52NrT4BUWZXgna0Wk/z6dHymChzdLRBtCrHepgn4XjpvfUG3PyuJAsT1/bDEue
         jW1lX8nkpmu+0YfeZjIfAROkiR13YnTWg+HexqmD6DQkq0bS2Bays5spVaUvYqa7chun
         fZ0auXeN5mY//uz5KumrzwosLDuTvORlAVzP5vTsuo8qndly8Kk/HjslrjtxlnsV59Wa
         x57vdtSY8hyNdS6hIoJg6UDZ2moGNtJtJGjc/KOQ+lxkX0kru56DYvMZAE8oqjKvCVoJ
         T4+Q==
X-Gm-Message-State: AOJu0Yx54UX+Yje8whntTwXFfP1xadrZIGuJzK7pVq32eIPztoZALXkc
        tWUICP2ZxRWuVhO9ZQNrg/kjj5OS9BNCqDB/iIHY7A2zYwFxnCVbKFPEMRSTtwUbfSsWFMwMK4a
        Ja6hRTvpTNcEo
X-Received: by 2002:a17:906:74d7:b0:9ae:381a:6c55 with SMTP id z23-20020a17090674d700b009ae381a6c55mr1378296ejl.15.1695809059650;
        Wed, 27 Sep 2023 03:04:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmN02eFnLazgdLvCsE4aIpvv85cQAxc2Mn7LvlaQAew+BPjDmZY6V28rBlKlBRI5vbfcbM8g==
X-Received: by 2002:a17:906:74d7:b0:9ae:381a:6c55 with SMTP id z23-20020a17090674d700b009ae381a6c55mr1378279ejl.15.1695809059339;
        Wed, 27 Sep 2023 03:04:19 -0700 (PDT)
Received: from [192.168.10.118] ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.gmail.com with ESMTPSA id cb25-20020a170906a45900b009ad778a68c5sm9112500ejb.60.2023.09.27.03.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 03:04:18 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
Date:   Wed, 27 Sep 2023 12:04:17 +0200
Message-ID: <20230927100417.792427-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20221201102728.69751-1-akihiko.odaki@daynix.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

