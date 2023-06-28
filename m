Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7931E7416E8
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjF1RDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjF1RDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:03:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE451BD5;
        Wed, 28 Jun 2023 10:03:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-2633b669f5fso745455a91.2;
        Wed, 28 Jun 2023 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687971822; x=1690563822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7X1MQ2jmu23RjDWRI9rJrkgFC/BK54cuNgKhdsqxLjU=;
        b=Z4gRdDg6dloZgXdyBlbQ+lpXAXWHb1k80IPgfN9UMMgQCqed2mr22Cl4qi0bhnMi/l
         3EApUeRENd7MeS/DHRiHUYlP4pwF2n7dsv/6g+wVobHTErIwwbTesDTfKEppPHP7Yq3U
         /WtUmZLwH9EvJCz8afkSBL0xnNdGcBAzINSZu2ZZpLhrHS4pRr/wo9Q0u5/h59P1n+yo
         2Ldt9IV/DUKU8T/ylQeMhLLhx0FkWOGKih54m1bxGZ53T3pC+yVN8kEQtFHS1akyjXJD
         cO7+P1cYD+gB8cBpZb+tXyLp5f2Ajopkyr3j5vw7fXGVvsbl+ifpiqCFg0DlP0G+9zB2
         5UTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687971822; x=1690563822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7X1MQ2jmu23RjDWRI9rJrkgFC/BK54cuNgKhdsqxLjU=;
        b=GWYFqmGHnxrQCG5WhGc+8bqZcxt1izFhyv9MiADqQhv8Oz+74Pe8MR7iBP34Mdv0la
         ZVSS098IdzxdY/OfQBIYSQ9FtT+U1cov5fGQ9RKqbXq1y5Nyz9pILR+P/pDOld1oXHrh
         5IQiW9/0N08LO7GUe1ZsExjdn0Fx8jnj9ngwmEvvzqDGCX8e07a2MhX3EUj6QmFFIBAn
         rOb/mJf3uLby0UXEUcE75Jn6rR4MU8Zu7F2Tw1V2qy0X+J0Z49AxeZZb9Ck3BB6C4UhZ
         cqgOHuNwdJiZnDIRw12FQ9x3wjuY47he3iGSDOUidgi0TYHy5+rh+T3lNsW1xL8EW2rK
         SW+g==
X-Gm-Message-State: AC+VfDzykJWhK1fPjmxqbq+90W4UIKT5bXWrer/ay0PuT3qspq0/iSNI
        8PNU6fP5+Q2yIDnpOf5dqKY=
X-Google-Smtp-Source: ACHHUZ4woOfcDRZoR6fRC0mD8qdnmXF08MYeIWpnENA+znOobZQnQkaxXVwF8L8R3yHfioJB/vJABw==
X-Received: by 2002:a17:90a:3d82:b0:263:41ae:8163 with SMTP id i2-20020a17090a3d8200b0026341ae8163mr1765697pjc.12.1687971821556;
        Wed, 28 Jun 2023 10:03:41 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e81200b001b016313b27sm2082416plg.88.2023.06.28.10.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:03:40 -0700 (PDT)
Date:   Wed, 28 Jun 2023 10:03:39 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230628170339.GE3436214@ls.amr.corp.intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
 <20230628064156.pblgvaks4cvulb3g@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230628064156.pblgvaks4cvulb3g@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 02:41:56PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Thu, Jun 22, 2023 at 04:16:29PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Add flags to strut kvm_gfn_range to indicate who triggered the callback
> > and new memory attributes.
> >
> > TDX needs to know the reason for a callback by kvm_unmap_gfn_range().  mmu
> > notifier, set memory attributes ioctl or KVM gmem callback.  With TDX,
> > zapping a private page from the encrypted page table and adding the page
> > back to the same private GPA results in zeroing the page, and the guest has
> > to accept the page again.  On the change of memory attribute from private
> 
> Is this part used to explains why on MMU notifier only shared pages should
> be zapped ?

Right for TDX.

> > to shared, zapping the GPA range irrespective to private-or-shared and
> > expecting the fault doesn't work for TDX.  Instead, zap shared pages only
> > and keep the private pages.  Concretely
> 
> Do you mean:
> 
> On the change of memory attribute, zapping the GPA range irrespective to
> private-or-shared and expecting that the EPT mapping for attribute converts
> to doesn't exist at the time of changing the attribute, zap the "from"
> attribute range only and ignore the "to" attribute.

That's what I meant. The requirement seems specific to TDX.
I'll update this patch following the suggestion by Sean. [1]

[1] https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com/
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
