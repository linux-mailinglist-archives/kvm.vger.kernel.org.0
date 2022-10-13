Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105B45FE369
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJMUlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 16:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJMUlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 16:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A860616913E
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665693657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=GVcQyG0Pt83cJ8LbhK8Kf5FmwMIlXEGry1i/TtKAUT0LANJIMJj9KvORJXEdfIXouOAV1N
        OQ2R2wmxTAWuHCXsfPhYNVh4/lcU6aNCciK1F0JQnkFNb6s22tXVMSoFomxVebEUMGvCO1
        rDtOnY4E0odHgOaE/1mSxzmODxgCBwM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-206-vtbjo4QcNTWMf4zxFA0Vdw-1; Thu, 13 Oct 2022 16:40:56 -0400
X-MC-Unique: vtbjo4QcNTWMf4zxFA0Vdw-1
Received: by mail-ed1-f70.google.com with SMTP id r16-20020a05640251d000b004599cfb8b95so2224492edd.5
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Y9yopp7qo/7lf9woHkNRarSWsegwWsVD+nppf35IFzu6kauIKUawm+2/iwwrCq6xUd
         aolhsWQIEfbUfyZrXF7Pm4XYmuqzkOwk8YTfFWp1pbeSs6Ng6SHDXk+qSaoJiJa3R5S1
         ZQH1PrZcMa4vmRS17uaGjIybuMXfBN71ThMMYCu2d7rueKka3LSvC3qdGYYwadBwg9SW
         0Bqq4i74NGiAAGULGwRYkqMjQKMkjx+emIMTRgxhiaOIShyjyeAt7qD0HJGjpfZt9HrE
         yTwypVng/0N9EySTXKEpqWkI7sw7CHXJutqniI9ba8zcgY5B4C7dr6JaZRWkOvHiiH8w
         Y24w==
X-Gm-Message-State: ACrzQf1hMcRNDrWVn0GF9aFPAWJKZxHjsqP83G82LoWiKAyutB78wB5Q
        qZXCnKc3dcW9250syQo6QESwSTozBpgGvg/NefpBnWm64quZRXZo630CALcNI4DqoKAUmWOGNGZ
        eGLbZtH+2RgMB
X-Received: by 2002:a17:906:8a6a:b0:78d:f18e:5d6f with SMTP id hy10-20020a1709068a6a00b0078df18e5d6fmr1128074ejc.489.1665693655459;
        Thu, 13 Oct 2022 13:40:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5CuXGF8D90Ul/CWpmGO1gBHsU8F7mPmSVchIAbfOj9j+JgyYlwIizY1VKaJKQ0rb0noNEZRg==
X-Received: by 2002:a17:906:8a6a:b0:78d:f18e:5d6f with SMTP id hy10-20020a1709068a6a00b0078df18e5d6fmr1128063ejc.489.1665693655275;
        Thu, 13 Oct 2022 13:40:55 -0700 (PDT)
Received: from avogadro.local ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.gmail.com with ESMTPSA id g18-20020a1709065d1200b0073d7bef38e3sm395970ejt.45.2022.10.13.13.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 13:40:54 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v3] hyperv: fix SynIC SINT assertion failure on guest reset
Date:   Thu, 13 Oct 2022 22:40:52 +0200
Message-Id: <20221013204052.653365-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cb57cee2e29b20d06f81dce054cbcea8b5d497e8.1664552976.git.maciej.szmigiero@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo

