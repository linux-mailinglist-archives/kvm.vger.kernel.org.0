Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F226FD28D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbjEIWT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 18:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjEIWT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 18:19:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA25E5C
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 15:19:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1aaea43def7so44742445ad.2
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 15:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683670757; x=1686262757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=97P6niZFRFf/HHS0XuApR4Gw+Av8dWivDdLORSGJDP8=;
        b=NZybfF9HDUsyXWRC364byOFxu3f1tWyKsUz7+55Ad4nKku3jTfcJa4iyE+fuEythcB
         pfezWVcHdJa3T/6s7ogqfTthNnvEp83C6JAmO0qIm000LLVF0/VOUfWLVAojHU69Vo6r
         YKB6Wg3h+hoA3Kcb9ikkHjkPxXN+cfGyQPupMN2tgcM8se+HHscpnRBxeU+KGe9tytfg
         7DHAaItb2ckU+H8e+xAl1koXhopo8nc7TB069/+2EPsdAeAO6MmAS9mkZX4260EHDzjZ
         pMRvzh+64NMoWGla/JNs4wSLrglp+59SKTmqFwvwWZZFXthf/vqQKo5k8Y5uubdkyVQF
         k29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670757; x=1686262757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97P6niZFRFf/HHS0XuApR4Gw+Av8dWivDdLORSGJDP8=;
        b=PZ/55TBV+V8tYDbR1qWdbuI6uo8ToQjboSfrFpLBv9j+9zLh8eXDfTM7OrJhRGZ4yr
         tVvssLC8Eqj6Bg3/Mz1on/cuQBcmzVf2mRSjskpoZxJ5QxtZJ3mL0Ol/BwzPq4oHZumR
         oTz/CPajNw7pobwBJ9hpRrq9ZSOm64LUvkBXiJ6jOsVvtgdEMFJ9g4cz4XM3OmgCzrvL
         jnV5jfKdGdEEXzlK9AmQAv1XCbF6xlyR5FeLyUbztEzZ4ieTcAIcTyHMuIhyGiMfn6SU
         V+THCmEfEnMthKjf0S8N6RWSKVWMJ8+eh1xm+AxN2FS02d0r7szp1L6eVV1YlRRrhL5r
         7hzQ==
X-Gm-Message-State: AC+VfDx5h7XZNl4BO05b9vYUDfJmLF6e53CB2Fy3p2mkbPTsmUVlcGgi
        JseaTcuM0UtW0iX7wXobO33S1A==
X-Google-Smtp-Source: ACHHUZ5GEq8I42wC+TGBklQvlCmhdNY72eJQYazx+WQ9pYBR0rfPTY6Y2qD4UQemt+kSm5ksJqYc4w==
X-Received: by 2002:a17:902:da90:b0:1a2:2091:eeae with SMTP id j16-20020a170902da9000b001a22091eeaemr19021363plx.40.1683670757461;
        Tue, 09 May 2023 15:19:17 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b001a6ff7bd4d9sm2153872plj.15.2023.05.09.15.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:19:16 -0700 (PDT)
Date:   Tue, 9 May 2023 15:19:12 -0700
From:   David Matlack <dmatlack@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFrG4KSacT/K9+k5@google.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
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

On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> Upon receiving an annotated EFAULT, userspace may take appropriate
> action to resolve the failed access. For instance, this might involve a
> UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
> migration postcopy.

As implemented, I think it will be prohibitively expensive if not
impossible for userspace to determine why KVM is returning EFAULT when
KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
decide the correct action to take (try to resolve or bail).

Consider the direct_map() case in patch in PATCH 15. The only way to hit
that condition is a logic bug in KVM or data corruption. There isn't
really anything userspace can do to handle this situation, and it has no
way to distinguish that from faults to due absent mappings.

We could end up hitting cases where userspace loops forever doing
KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...

Maybe we should just change direct_map() to use KVM_BUG() and return
something other than EFAULT. But the general problem still exists and
even if we have confidence in all the current EFAULT sites, we don't have
much protection against someone adding an EFAULT in the future that
userspace can't handle.
