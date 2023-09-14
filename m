Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85E779F665
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 03:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjINBcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 21:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjINBcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 21:32:45 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4BD10CC;
        Wed, 13 Sep 2023 18:32:41 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-414b3da2494so2303061cf.3;
        Wed, 13 Sep 2023 18:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694655160; x=1695259960; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L+YKSA6KAPAfRaImt9TgHHgpGnpBBCNQ6vAz9FWPYsc=;
        b=m4flkd8cTN9aK/4Wl5bA/rNTEAK3JwZUj0MElF4n49cTQvnSsRVGWhEhOIEU+pD1Vr
         xsUCkyBCJCTXRdsGltmJIMYb7vIU6XD+kgyCSBYGfr1GVE+EmlbiRSJP22HNu8NHEVUU
         1e2AaUv/zLognrDNpAyTxbL46ZQdkZI21Fx1EN5MoHXxStQJF9qXPRCGqvRNIc8ZKAPy
         6ABhN40dHxPIao/0iETeVhEeoor+o5SrQZhC680IeZ7wbRoNu7cWVo63Zavl9OhXlUgl
         U2CKqProSBEc7vO8meFxTu/d1DcFMW+FzeDGN49zzFuCcMIt4NNwSTbYL1xd2Oghxykm
         LCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694655160; x=1695259960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+YKSA6KAPAfRaImt9TgHHgpGnpBBCNQ6vAz9FWPYsc=;
        b=okJHUb4+GhH+J+ZerwE9UWp176FzlVIXjQq1Ef4IM6ITfbMdblxwhIzg9R6eZspxSF
         f3F4+OpDIJp5KYl0VlQWagZ9D4ICefZMvJJ7FDCGlTwHmhihmlS+MA9PAOS5knWVkBRx
         tEh4Jmxm7DNVszzeKVcaBlamD7pjQIWGmf5bGK/jeQz9rsnSM8Ty/qA577ucfU5eKWmP
         hs9sPAigyk86NEKKkk7wznJi71qkKz721KZAX4q6qyj51ACssJzt3h8eOzNbbVfo4mhO
         n72psIw5zLzrAyiLuqpm5guKVUK2/aU7d3p2YvB6Ig2sR/BPv+wH3b+HHyDrv1PW8Tz5
         9ejg==
X-Gm-Message-State: AOJu0Yyus6Z8D/v+KjQTRc5uz8QWaTp02GCLYJlbLVeJG4w2CrQBUTNS
        xBiOu5Biw/IRlSPRKLkcKiiY4mcrXkyVNg==
X-Google-Smtp-Source: AGHT+IF7N6bmHeI/EjQa0qJcPaU06ldQ9gE/DgkLylKZAYikT+MO3weeu9Chov8N+OEsgfcHDH26Jw==
X-Received: by 2002:a05:622a:448:b0:40f:da0c:aa24 with SMTP id o8-20020a05622a044800b0040fda0caa24mr4575180qtx.56.1694655160563;
        Wed, 13 Sep 2023 18:32:40 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id g16-20020ac870d0000000b0041061a16791sm149723qtp.67.2023.09.13.18.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 18:32:40 -0700 (PDT)
Date:   Wed, 13 Sep 2023 21:33:10 -0400
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
To:     kvm@vger.kernel.org
Cc:     leobras@redhat.com, seanjc@google.com, pbonzini@redhat.com,
        dgilbert@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQJi1lzAqQxMFiHW@luigi.stachecki.net>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914010003.358162-1-tstachecki@bloomberg.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023 at 09:00:03PM -0400, Tyler Stachecki wrote:
> qemu then both ceases to put the remaining (non-XSAVE) x86
> architectural state into KVM and makes the fateful mistake
> of resuming the guest anyways. This usually results in
> immediate guest corruption, silent or not.

I just want to highlight that although this is probably more of a bug with
respect to how qemu is handling things, the original patches from Leo are
starting to appear in many distro stable kernels and are really putting a
spanner in the works for maintaining VMs that are long-lived in nature.

At present, if you take the fix for PKRU migration issues (or if you are just
in need a more recent kernel), you are dealt with a situation where live-
migrating VMs to a kernel patched for the PKRU issue from one that is not
potentially crashes or corrupts skads of VMs.

There is no fix for qemu that I am aware of yet. Although, I am willing to
look into one if that is more palatable, I filed this patch on the premise
of "don't break userspace"...
