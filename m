Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A3B7D53C8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 16:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343639AbjJXOUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 10:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbjJXOUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 10:20:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FBB12B
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:20:16 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4084f682d31so33484225e9.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698157214; x=1698762014; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N/RTcnvN+s3qfbGL8IxZ3YpZboBFi25HRb3Ev7DIpus=;
        b=PxKzjB2Xvlx2NurXuav4c83WIxHcdcH8zLe5EByhS6+/mV+WOzP4kUmJgi9h2TPIAy
         yGgqpt+JMDUyrGLYtKZatY1Xfv+ep3KUROLRI0JDwhbTn4U/9KDEctzLRiSFJo7o8PSb
         GRCV0DsdNvcQlWYvSZ0Loi4Gcsmc1HCcuNKHR9eFmJQT+MpG0nYsHgTGeaLp5u0iVLqG
         iURNF8lD6JwnyI7n3Uh2vpvagowCnilt1DDktNFKL9ldPWY+G1SmWLLSJzERosCJsoqX
         alQnzeBHe955/qqJqCAD7MMyhU98xnzTs9sdE0rpoSKSG1nLrtFrjn31qXAwrsTjcZT2
         vG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698157214; x=1698762014;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/RTcnvN+s3qfbGL8IxZ3YpZboBFi25HRb3Ev7DIpus=;
        b=rtM30Tu/BnfUwZnqKr/IB/Ygkn3BPV1ScWjb/8VzWTFon9TMW3zCbIYAzYz3g6IEV7
         Q3wOl8hVdxlKW0doxM/CKXzIv/2Fl0d6ntV+apu5/m+nFX4/MI4vwD/Zitp7sMROJlnw
         NrSgL+JTUcmZe0Dyt8ORGnSuMOpegEMcvDKsG/ElxDsZ6ar+eWjctDth5kGRzanoFZLW
         K4onFGOadBYaXIvX7PKwnoMZ325iyynl5qS/uxelrxzy/ofFkPlTpc+4sAYc+HlFy1an
         LtQCNeGv/AQI6q0M7EeO7c2pVmnkmsHw0Jpj9senoV/PEP9lo3VywRSMJ7MT86ih/PTR
         A3IA==
X-Gm-Message-State: AOJu0YxiQDSvmcjjE4FPvTpHzHHzEzLIyeQqKoBop6WPofXzuj3GoTCR
        l1wHiWQr4YRtsAPMfqR3Jp0=
X-Google-Smtp-Source: AGHT+IEyITPkgMCMhYLgEPjPPOpjFI74iF5+LpLQdanMOxh59eFvYc4PmD1+hbF9zetlTx+c01olxg==
X-Received: by 2002:a05:600c:5254:b0:405:2d23:16d9 with SMTP id fc20-20020a05600c525400b004052d2316d9mr9323630wmb.21.1698157214277;
        Tue, 24 Oct 2023 07:20:14 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c358c00b00401b242e2e6sm17039468wmq.47.2023.10.24.07.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 07:20:13 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c18439ca-c9ae-4567-bbcf-dffe6f7b72e3@xen.org>
Date:   Tue, 24 Oct 2023 15:20:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 12/12] hw/xen: add support for Xen primary console in
 emulated mode
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-13-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-13-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 16:19, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The primary console is special because the toolstack maps a page at a
> fixed GFN and also allocates the guest-side event channel. Add support
> for that in emulated mode, so that we can have a primary console.
> 
> Add a *very* rudimentary stub of foriegnmem ops for emulated mode, which
> supports literally nothing except a single-page mapping of the console
> page. This might as well have been a hack in the xen_console driver, but
> this way at least the special-casing is kept within the Xen emulation
> code, and it gives us a hook for a more complete implementation if/when
> we ever do need one.
> 
Why can't you map the console page via the grant table like the xenstore 
page?

   Paul

