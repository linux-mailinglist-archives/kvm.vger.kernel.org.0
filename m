Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7814ECB38
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 20:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349625AbiC3SEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 14:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349635AbiC3SD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 14:03:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F93210428E
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:02:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so855295pjf.1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 11:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1t7ZTcfgKbtCrh+Z8QzaoA6bXs0GJ9EG7KZ7T9mNkyo=;
        b=Qnc0FbV8QW9nWNUOQwd6/VL3i7W1mRJNkjUHl2lrMu1esd+LZ8H5X7HdBuqE7iT02e
         BbcHWea0WsPYpgJZd1t1tLzqf8zAvoF3JrXkRfv9Qf3rD2plPb0pqBL5YozYI77OG0Jm
         inbNIW+pd/UC9m0MMRX5dl4x1tcS3hmOwxrJ4YkrTT5Aj+AxPnQqC/Y5C7rMYG2TDUit
         X54n5lQR9HCBt53ElkMeirueeHikr967anl32qZ9taBIT/irIR0uxCOODF/WHJq42sSz
         x0r6FrOV5tSe3kvftlYtWDC2qhaSyLTsI12TACUxUfsVxe9ZR6dOZi4IqSXRpqQc9wCD
         IQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1t7ZTcfgKbtCrh+Z8QzaoA6bXs0GJ9EG7KZ7T9mNkyo=;
        b=JqypK7H3Fg2VG47D0N+W6sg4yq+9gATrhT5o2/+zqUPR+cFU43G6f+Z0p3OzGuCHu4
         5CUxk5++PEpsy2cy/NK5Ew3RaGsuijEJ/3Xp22OkgfIalzrndVkQ01z6D0Zw9mW146vs
         5+CHZqZQH/P9Leo57mn4idSr9XcJ6cBJiXhMNRpw3Op413sOR+GIWfmNs61eFgr1d1rf
         WOcgL49lVte1Mfbm2ULyHYrBrS6vb5ZL+b26ka00aedFIpXGj6L5fNHYi7b8n9EiEIbE
         XLbEodCPsxRXTm7J770tVL7Y+wmLol/X7mf+kJ98RqIc5tHyV98XzXNVvELPyX0fA7/k
         kBXA==
X-Gm-Message-State: AOAM531nbcMw8x6IYrEjgIbq8QBoDBY3tgL79DfFRBCkrvq50FUS0503
        qRZuQUDu6km/7lLPcGP7If/89AdKFFNrxQ==
X-Google-Smtp-Source: ABdhPJzh0mo9Te1Jek3HXgFffthHCfqhTf4wEFIFy/INCb3Ksp0Y0whGDEpzp1MDM0LMhP07MuB7fA==
X-Received: by 2002:a17:902:7c0d:b0:155:d507:3cf0 with SMTP id x13-20020a1709027c0d00b00155d5073cf0mr501879pll.103.1648663331634;
        Wed, 30 Mar 2022 11:02:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id be11-20020a056a001f0b00b004fb29215dd9sm14648311pfb.30.2022.03.30.11.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 11:02:11 -0700 (PDT)
Date:   Wed, 30 Mar 2022 18:02:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 10/11] KVM: x86/MMU: Require reboot permission to
 disable NX hugepages
Message-ID: <YkSbH3XR0YFzrZik@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-11-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022, Ben Gardon wrote:
> Ensure that the userspace actor attempting to disable NX hugepages has
> permission to reboot the system. Since disabling NX hugepages would
> allow a guest to crash the system, it is similar to reboot permissions.

This patch needs to be squashed with the patch that introduces the capability,
otherwise you're introdcuing a bug and then fixing it in the same series.
