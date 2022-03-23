Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEED4E599F
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 21:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbiCWUPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 16:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbiCWUPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 16:15:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036E8933B
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:13:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e6-20020a17090a77c600b001c795ee41e9so2387262pjs.4
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87pHWuuOeFMvF2m5qztZ+3SsMU0YaX9iK1MT2LhBueA=;
        b=i0dxUGbj8ISDKpsBHPxbsOd7JTE3/LT6oezBVS6Ygw/H9fWokSh4gd5bkwFf/BPoyD
         tDzGiwsddBiPHtxhLGhPFOn0MV7GUVY83bsrHiJI49gXo9Bpe/vfnzxjhI/FAP2yVj0v
         Qj+bKYYF0Qbd7D7EZCx4bzcqvRb9A7zCUrJv0Zj6zKMkOvUjnsSFRA7S/N2bOIuHnPRC
         Cd6lsZdoZLnJlya/JqvEo0lj4HBx5zoAFKPATsBZpsixaO94Jcqb97e/8KwnjLbPmtCQ
         78wzcsMeqUOYIR3ui7b1LgCEMrubpbyqB1VLqscEOiGzIYkMsK090kdy9qWKW2uW7qDp
         OFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87pHWuuOeFMvF2m5qztZ+3SsMU0YaX9iK1MT2LhBueA=;
        b=jpwPBIVedwdrMRPyMqGFI81wlqPk2iEbE07W+ZSrNHrLiXgFUR94/rCsH9M0emJW4/
         tYbOEWF9xzgyWcXHq5iG8DdtXpzJSG0NMvEw7uWV6lLA1drkcEwzmTYQ7Q/O+m7PdC7a
         SNl/K/hrbJ5fgsk/Hi4vS7DbjbpnS0kaHByK/ltw/OsQS92td544rvejigJIF1o0LngH
         C9L7A5O43db/TcKUbHENd/RPrHtL2ePgyMt2Ew/m+eqkUplX7gF2oHtDs44HmbRTu1XO
         yrx5pEfJlcFL12oNUXu3rbquvqw/TUFTnikPVYTXNqSORcTnRmLKXE0bDg+gYttk2SwL
         n3bQ==
X-Gm-Message-State: AOAM530lpqAvhndiNrFX8S62/hoJNpx+AKAmTP/zGeTOolEv2V3s/HYW
        D/FjGAnQcZdZdPWHFJiFr2nmsQ==
X-Google-Smtp-Source: ABdhPJxW0nWbCs+fKb2VZ7Dp78kvE0grHKXIDDZuoMohOONgFKBhBJ2rsNLjNNxzfGq6158DqpeawQ==
X-Received: by 2002:a17:902:7887:b0:154:4f3f:ec54 with SMTP id q7-20020a170902788700b001544f3fec54mr1810342pll.156.1648066416930;
        Wed, 23 Mar 2022 13:13:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id b2-20020a639302000000b003808dc4e133sm505007pge.81.2022.03.23.13.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:13:36 -0700 (PDT)
Date:   Wed, 23 Mar 2022 13:13:32 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjt/bJidLEPsiPfQ@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjt6qvYliEDqzF9j@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > Add hidden or reserved ID registers, and remaining ID registers,
> > which don't require special handling, to id_reg_desc_table.
> > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > or reserved registers. Since now id_reg_desc_init() is called even
> > for hidden/reserved registers, change it to not do anything for them.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> 
> I think there is a very important detail of the series that probably
> should be highlighted. We are only allowing AArch64 feature registers to
> be configurable, right? AArch32 feature registers remain visible with
> their default values passed through to the guest. If you've already
> stated this as a precondition elsewhere then my apologies for the noise.

Aren't AArch64 ID regs architecturally mapped to their AArch32
counterparts?  They should show the same values.  I'm not sure if it's a
problem (and if KVM is faithful to that rule),
> 
> I don't know if adding support for this to AArch32 registers is
> necessarily the right step forward, either. 32 bit support is working
> just fine and IMO its OK to limit new KVM features to AArch64-only so
> long as it doesn't break 32 bit support. Marc of course is the authority
> on that, though :-)
> 
> If for any reason a guest uses a feature present in the AArch32 feature
> register but hidden from the AArch64 register, we could be in a
> particularly difficult position. Especially if we enabled traps based on
> the AArch64 value and UNDEF the guest.
> 
> One hack we could do is skip trap configuration if AArch32 is visible at
> either EL1 or EL0, but that may not be the most elegant solution.
> Otherwise, if we are AArch64-only at every EL then the definition of the
> AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> the problem altogether. What are your thoughts?
> 
> --
> Thanks,
> Oliver
