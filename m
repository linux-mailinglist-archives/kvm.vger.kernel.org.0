Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475B773AECE
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 04:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjFWCye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 22:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjFWCyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 22:54:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234882110;
        Thu, 22 Jun 2023 19:54:32 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so159317a12.0;
        Thu, 22 Jun 2023 19:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687488871; x=1690080871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t2juHvoY/mcC9iiq57nWmyC1+9+zcIWhH/stlgFuOrU=;
        b=pYEzQadLI48mLv2E3taVm1A3CUWVlYAWQXiyu8DM4jjj+0SwiaHhjQMJzx5D5IxFs0
         cpSlN74mn6Tye6vQ2ArCd1RZxMXLGz9M/+JFzmgFh0l5Xj3t4jGJuybFTfbi39nkSmbs
         YnFv8l/Nb8p37Rfmv2GvAkeh/eUjWBNYrii4IRyDetIIMu4zgq9U6dNA7ZPjEcY8NS+d
         mryz4m5olAt3SrjSuJLizb+lNxErUljkb7RULtHMkBebBop+4NnuP77x5XW9EkG2auQF
         QGKtUOKjO6yw5ET239gNLcxvYOKYTXrYYDNLeFLV3i5kFgXjmEdOapK8PXQx5aPtLshC
         WNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687488871; x=1690080871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2juHvoY/mcC9iiq57nWmyC1+9+zcIWhH/stlgFuOrU=;
        b=jzU8Vbyp2UsNRyADot6O1RdxRjyJANl58uJCnRUlhCW8fFHgQVZcTZkX5GNlOL27KU
         9dT8Qxyw5/4RmnMh0SqQiGGbifpgdphNl9/zm3Yn06qjnHw9EKTwYjWZ+8f/oXFKmkuU
         Pqus9gQGifbgNGGJOqtssfEdZ4Vsc/kHMfRMFvPF6Mwsl8PtM7JVBHDxk4b6O9qTQXdD
         QOiHZprmEIX9LaN9ZVOL00j1kapmvwjZl48Y9S1KATk6JaIL2h4Cz5mhfClcQT+PUozO
         d2FZ3TxthdTl1C1LYoJl3hW6Dmm0W2Pcwba0IRFdJsTm4OG9k98TYQhUbb5evS6r2MIk
         B8Hg==
X-Gm-Message-State: AC+VfDwS1QoiPGHLSAZt2IkFj+RRMXR+NdZYaMiUwQPteiYEcTmVT6Y4
        QaL2jfrLtdTGki87hW1i0bI=
X-Google-Smtp-Source: ACHHUZ5JJ2k9e9xfcKcc1NjbpAw2nX2k3oA3LDDnRxY6qZDvpS0ZU1fCwskxROcZ6ZRXfW/QBXkd1Q==
X-Received: by 2002:a05:6a21:900c:b0:10b:6b1f:c8c8 with SMTP id tq12-20020a056a21900c00b0010b6b1fc8c8mr18587734pzb.31.1687488871379;
        Thu, 22 Jun 2023 19:54:31 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id k4-20020aa790c4000000b00652c103d534sm5088322pfk.118.2023.06.22.19.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 19:54:30 -0700 (PDT)
Date:   Thu, 22 Jun 2023 19:54:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "ackerleytng@google.com" <ackerleytng@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
Message-ID: <20230623025429.GB3436214@ls.amr.corp.intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
 <37b868c53c9f35e8ec051573562a4598df38d72d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37b868c53c9f35e8ec051573562a4598df38d72d.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 11:28:22PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-06-22 at 16:16 -0700, Yamahata, Isaku wrote:
> > The upper 32 bits of error code are discarded at kvm_mmu_page_fault()
> > by lower_32_bits().  Now it's passed down as full 64 bits.
> > Because only FNAME(page_fault) depends on it, move lower_32_bits() into
> > FNAME(page_fault).
> 
> I haven't looked into the code yet, but the last sentence around
> FNAME(page_fault) doesn't make a lot sense IIUC?
> 
> For instance, we can have a shadow EPT table when EPT is enabled in L0 and
> exposed to L1.  If we want to pass 64-bit error code to the handler, how can
> FRAME(page_fault)() depend on the lower 32-bit value? 

Probably "depend" was too strong. In short, I wanted to not change the value
passed down as error_code from FNAME(page_fault).

FNAME(page_fault) calls helper function to walk page tables. Some check
PFERR_IMPLICIT_ACCESS_MASK(48 bit).  If we don't mask lower_32_bits(), it can
pass accidentally the bit.  Maybe we can audit the code carefully to check if
IMPLICIT_ACCESS bit doesn't matter or fix it.  But I don't want to do it with
this patch series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
