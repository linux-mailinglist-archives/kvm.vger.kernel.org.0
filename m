Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBD531C06
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiEWTUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiEWTUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB098183AF
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653332081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=LMXQGyLkmab4+K6qS2rgyR+Uck05Izn5Wc09E2bA7nse6Pe9I1jeiaMKCBdIEyTAEQtaIg
        2Wd3oFTPFItwIjrZqcY3eopSAIT1G3cLNjx28PwWCZT1L+mgQNE5M1/4tFmlTwjgdj9a2l
        coHgdOUZbcp18PXm9SZ6DNwVWu6wGaM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-8qPZFKkGP1qxnt0Qb_A_hQ-1; Mon, 23 May 2022 14:54:40 -0400
X-MC-Unique: 8qPZFKkGP1qxnt0Qb_A_hQ-1
Received: by mail-ej1-f70.google.com with SMTP id gn26-20020a1709070d1a00b006f453043956so6475215ejc.15
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 11:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=XqZibzTVO4Wg6qKnBHfMJYDilSpv+voxuXzJKf+3/XliZzsZu404k3o/2GcIicbPR9
         BX0x2EUoPF+brcqjkzGUtmKv+f26/wF5+WPFIcL1kLU+wlsiX+l4e6PdPwg3Z69jdjrF
         mzTcP1Qc6cnlca7ALvT2PSQUWS8njkKRfobBbOnkS5OTh7BWKd5+CMP21XnuXNtYwvFG
         VNaF8eyzHEBjFEs6xLwi2Ywc2MRXlTn+RoUBwcYIp3nqTKtovNdvwO7n9XTc27zxKrkg
         cW2Lv5EFT4hkC6kFCv0qC3gnCREAAfa9BzL5WPGhUVwS624mMd7c7uMDGPbbi9alDpTJ
         1dXg==
X-Gm-Message-State: AOAM53265d6H7MrkKTcnNVjbLOhTjKdlYoyRbeOgO+RzpxF6uuVL1t6D
        BRpRcA6STr80SSCZzpWbJkqn30hql7pJlmCjWcX1w5JdgXjRmYmNoEatPEjBQHh4XEfd1FLFAq4
        CycXYcZ6lzkSi
X-Received: by 2002:a50:fd95:0:b0:42a:b7ba:291a with SMTP id o21-20020a50fd95000000b0042ab7ba291amr25054011edt.247.1653332079451;
        Mon, 23 May 2022 11:54:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlP4vFpiuwfDgCgLY+SMHgDrnRZVTVsHalTH3Umr5xRZAxRyaflx9PhmieSCKcv6MGdUosqw==
X-Received: by 2002:a50:fd95:0:b0:42a:b7ba:291a with SMTP id o21-20020a50fd95000000b0042ab7ba291amr25053997edt.247.1653332079232;
        Mon, 23 May 2022 11:54:39 -0700 (PDT)
Received: from goa-sendmail ([93.56.169.184])
        by smtp.gmail.com with ESMTPSA id kl4-20020a170907994400b006feb6438264sm3645800ejc.93.2022.05.23.11.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 11:54:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH v2] target/i386/kvm: Fix disabling MPX on "-cpu host" with MPX-capable host
Date:   Mon, 23 May 2022 20:54:37 +0200
Message-Id: <20220523185437.364606-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <51aa2125c76363204cc23c27165e778097c33f0b.1653323077.git.maciej.szmigiero@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


