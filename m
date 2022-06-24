Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53399559543
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiFXIUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiFXIUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 142E26F79B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656058805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=hwJGiHsvx6Vw2vGMLoIo6eigaMebBj++Kej1GUqqjAWigX5CFfv5xfzs9fp+8X1qqpe5CR
        xEMVCI9RYGQf5txvySTFDzusCiSzYrVA9G49O9FYd0sQhClxVXZY/wuwtCTBRcVwfiztpI
        xYs1vLnLfoY9L4G4QYgIOaME3paxGwI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-1SEzg_K-NMCL4d6K2LylDQ-1; Fri, 24 Jun 2022 04:20:03 -0400
X-MC-Unique: 1SEzg_K-NMCL4d6K2LylDQ-1
Received: by mail-ed1-f71.google.com with SMTP id f9-20020a056402354900b0042ded146259so1341425edd.20
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 01:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=tIyuQepg4w9W9O9m359JF1qQO7ZdtxAxXJyyjJJ7avtDUyvdyBIUSYnuyPvrU0tAkk
         GZLCYTN6ebE4c0g2mKTwxjxjh1ynj+WGJL5FYlOuAf5/6/M8jnxcTR5uw5xmE16nJeDX
         Ttowt3qjrAoA34wcacoXIXucjbfdBwIz0C67CTb+UfQmC5WBgn6lwlkdOE7f+m8iwq6/
         3xznBwqXm57Z+JcNHxB0NAgi5HDw9K5fXFT/A1Z45I5AwgXRhxFRObF+aRrWoBo2JeqS
         ZzCA/+Sg08fVlL4Z3w4ZEKWykfx3aQa8zXhwwBJv4pnRFgpQG4vn4nDQbBmGcqWK/fv6
         OXjQ==
X-Gm-Message-State: AJIora83lWKZA9rpVwltnd+0gI37NrLvrp0RokeQrFqxchonaq4yx/P+
        d4RRI2RJfAe2RgTsZ3sP8tRut0KIPm3eNXejyaA7rVc7ht1Hx/DxuCzG8gbaXRqKKaquYNPpBwQ
        PDZ6xXBrUafCz
X-Received: by 2002:a17:906:7386:b0:715:7024:3df7 with SMTP id f6-20020a170906738600b0071570243df7mr11959530ejl.543.1656058800595;
        Fri, 24 Jun 2022 01:20:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t+WRla4G3etl479U82MYkniMD7JPqeRRHuY04jV3stT/CSYd/bS+7jnNffsyn+WeluT75zjQ==
X-Received: by 2002:a17:906:7386:b0:715:7024:3df7 with SMTP id f6-20020a170906738600b0071570243df7mr11959309ejl.543.1656058797342;
        Fri, 24 Jun 2022 01:19:57 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id j15-20020aa7ca4f000000b0043559d9e8b9sm1386990edt.53.2022.06.24.01.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 01:19:56 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, linmq006@gmail.com,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kraxel@redhat.com, Kshitij Suri <kshitij.suri@nutanix.com>
Subject: Re: [PATCH] meson.build: Require a recent version of libpng
Date:   Fri, 24 Jun 2022 10:19:52 +0200
Message-Id: <20220624081952.245740-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623174941.531196-1-thuth@redhat.com>
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


