Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264C562E502
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbiKQTLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiKQTLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:11:13 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA687569
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:11:10 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id 94-20020a9d0067000000b0066c8d13a33dso1647974ota.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FWnLlursaYJKfOWPydpMGhECaxSct87sWPPYmZvjBnw=;
        b=Cz7wQpimV+YosOt9d//L2iWXvsIwwTN7+tjHjRw1UuXZTFbUfBv45GZ47lSCAi6EcG
         VLCxZlhWhKMLKfFv0VpaJ6NGzl9T2WpPOA2M7MVPeRDJmz+0+7kWkh8Dq5RGn36c5YZN
         RCkckS0hqvu2id02Rcg6k7XcFXzcNLD8MIzBGgWMWN0N0VHHd1fSFMQklCX+brbbuBgE
         ih/7mR/sPjlt/bW7MM8g1MVwu+GTjymRKZX2kFP8DUezPbyyoBQYIDFml/uoor40SgeV
         nSUMnBnJUmDecXZkRmTJfH0roB/Hyh4UDmNyK8ednN4Veb0goHe6OwvCB2TlDb1m3iQE
         C3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FWnLlursaYJKfOWPydpMGhECaxSct87sWPPYmZvjBnw=;
        b=hB+iv5RsbZRiEHb00ZOKJyrl7/5MFjJzUzOyHphRGLmL5qrGDXmAFzr3Xpry+viluF
         efWquKNloeEbP+6F+aUOxYXcqXOi7pNbt56BBcIO6SAJEhTaGzM9X6gzcR2Bky2X5MGP
         V7Bs/sx39VnWBYu8HRV+5DW9fH30Dyy0kB2/0YB5MDzLMAvdB6Y5p8RBBCS9A9WK+7oY
         0q2ZO8sUUoCmbaTvCrbZBumIg6yc4mDP/LqQyL1svwEfaUAxLcpVI7tJRWytd0NPqWTS
         ZS8KfsWpX7thRC3hemjDnHOdmA7Wv71AwcoIfq8uIPYcuqHVPpLTjlPeSoMpz2qH1hu9
         5zUg==
X-Gm-Message-State: ANoB5pnIrM8BlGUeefvQqs9zOcXh6voxESwqCHRJMjTN/vBqxG1rrIad
        dKBq6QcVDwx8PLc5BCFftJ6UzndUpk3ZogT7HM66NQ==
X-Google-Smtp-Source: AA0mqf72zx045VT5xpVnSFZ6Iun9LWo8yDAnd0PQxV+G2W6PiH+rxSFgg06B0VtTYQpHPSkqtismdJCDIQ6RZ3AVZE4=
X-Received: by 2002:a05:6830:1510:b0:655:bd84:a806 with SMTP id
 k16-20020a056830151000b00655bd84a806mr2136812otp.108.1668712269869; Thu, 17
 Nov 2022 11:11:09 -0800 (PST)
MIME-Version: 1.0
References: <20221117181127.1859634-1-dionnaglaze@google.com> <20221117181127.1859634-2-dionnaglaze@google.com>
In-Reply-To: <20221117181127.1859634-2-dionnaglaze@google.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 17 Nov 2022 11:10:59 -0800
Message-ID: <CAAH4kHZneEeJvH0ppJBEUqMQeWH_KS-h+BG+QkNqMV64F0PENA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kvm: sev: Add SEV-SNP guest request throttling
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Andy Lutomirsky <luto@kernel.org>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Gonda <pgonda@google.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

Adding kvm


-- 
-Dionna Glaze, PhD (she/her)
