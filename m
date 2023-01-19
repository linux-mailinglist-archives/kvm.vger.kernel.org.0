Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209C9674410
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjASVMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjASVKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:25 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1506A4347A
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:45 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso3581836ybp.20
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EOT9eV4Kc0JquJWK0pGFYqFerJBXhSm+YJKjLyVzJN8=;
        b=YitUAiBYTaN0SiCzFYGjvbCcpfB7v0h9M6uDRMAfJ81R+UgMrZw+QRtCsFtn/M4i70
         BnG921Ab0JRPCxnD3+zmJn27DeTsjCAC1VKNF1sWKXK6rAabFOWyuFUoSqehWPStnLmL
         Eo1V/YJc/3R7HHMim6jwvq7SYzTk4bAjtj9qzi4qoj86LoJ3jELkKwp0Bs3xER+Y2G9P
         /1Jfr/7++1gXp7mY5hDeiFP8QqlrCc3/l3GcfxnuROWqaKvVVs5ZyG+cgRr8VvwQqOJW
         6uvhFEenGjkAS6uUNbXgf5ok3J1RGGrhuXeEj46PfLKnneNeUZVRhIy+XwrdckJ0VfaV
         oasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOT9eV4Kc0JquJWK0pGFYqFerJBXhSm+YJKjLyVzJN8=;
        b=eXmB/cPdcjvhZq5aBkN+OszqBsFZc8CU0zfRbSMpg+9YwWQcBzu98W3J9Ibm9A8kEu
         eKHLF51ICeWWun5aCyJyTLaMKgEsFlbeFlxdWrgaf6XSHLalw/UpvNFn537SCX1MNtYq
         ChEYNXzl6//q9G8/mP0Ew6Y0n2Z8KhkbQKciCBrbnHhOXS6q0L1tpn1uc/9V1XLWsOPx
         5o0TAHVOzrFzOGskfo6j/Htd2tvQVXxgG697ojcX6u/IMJH1x9/S9Tq/w0/cUaZ1G0u5
         aQVyC8GcjW5nuRF+nnhBGmcv7aYZRST4j6rwKru1PtRRvoljY2EdeTaG/xjgP0bjbu15
         nfyw==
X-Gm-Message-State: AFqh2kqZ0hk4q4oXEk1WCncYKOGkdspJW+Lp4RBxos19Se8hDl4QI/oa
        fBxvqGi1VxsWvC5nRAejozmhVbubd88=
X-Google-Smtp-Source: AMrXdXsIy5dhKOY5TFiRb1J4OWU5UQmG/5+BoFhNFzdycREc6kHSTJHe6viFDb1gzItxL2LzyPg73/asy+0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:10d1:0:b0:4f6:8b57:701 with SMTP id
 200-20020a8110d1000000b004f68b570701mr899891ywq.445.1674162224321; Thu, 19
 Jan 2023 13:03:44 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:03:35 +0000
In-Reply-To: <Y3e7UW0WNV2AZmsZ@p183>
Mime-Version: 1.0
References: <Y3e7UW0WNV2AZmsZ@p183>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408903027.2367423.16204813645884492437.b4-ty@google.com>
Subject: Re: [PATCH] kvm, vmx: don't use "unsigned long" in vmx_vcpu_enter_exit()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Nov 2022 20:05:21 +0300, Alexey Dobriyan wrote:
> __vmx_vcpu_run_flags() returns "unsigned int" and uses only 2 bits of it
> so using "unsigned long" is very much pointless.
> 
> 

Applied to kvm-x86 vmx, thanks!

[1/1] kvm, vmx: don't use "unsigned long" in vmx_vcpu_enter_exit()
      https://github.com/kvm-x86/linux/commit/59fc307f5922

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
