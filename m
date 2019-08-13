Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09D58C155
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfHMTOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 15:14:44 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38319 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfHMTOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 15:14:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id m12so11044673plt.5;
        Tue, 13 Aug 2019 12:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DfaDqPxiZMNZIbjsgNm0UGrK6HEhpQEX5jhA59JEvVg=;
        b=mGZu1L4UmgRrdfLrcBt65H8WlaGjVqPf6hmI3iKS3BEHrG04CR+SIlyc/snB3GFpnQ
         vZCBxE8IVRufoJL800Mk/F1qMWc5Vy82hWnKqJ5uLOGHkZSslTpy/S1vyYAXwU94N8l+
         SIRY/lUnbTREy3ktiakmQ06cjhAsoo3dK4YUktGLrXpxEyH1i+g64KRwP07RvO4V90k4
         mH6YqNc25+W3rdO63XMT/YrQNNmwbrLJoU4v1Tz4gOAoeApKAY6qnicKuyH8fl8IhvUU
         C2hsmxZaro3ZW4RcEPv/bftiAQ8aG2hDA2FNDnxnnVtY0M4dIwEwO5JuhFyIHekcERy0
         mLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DfaDqPxiZMNZIbjsgNm0UGrK6HEhpQEX5jhA59JEvVg=;
        b=HoSskEokR1RVgnAzCmXtJ+D1Zw/0qEiIe7+HfXzUmr2aYps/JxRPW59Ptxtw8Lyp/K
         O53T3mL6S/vIhh8naA92vkXAI7OY+V8b+03UKCocyoFTwO2y/b2ef6LjqtPc6uRCMuft
         prKZ4Yt8hXSaPucQibYerAd7NT5FRZKbEAs8s41wUvM5rKOXF+Bs5Wbrh6DmkqB+XQI4
         jt4wAIC/nGPIwzMwdbfWdQFL3obHugGmhCkV3Oa54jdweOmSz6KLZbWZELfVdNj4gVV5
         wMlL2ZTfxkE3pES9j4/5Fdr8ASZf0th/5WRb9khC6wrFuQwa+hgsyJR2sKoyZ8714jRE
         A8HQ==
X-Gm-Message-State: APjAAAXNRvAwsAL7rpCmJ6LETpSBOXxBEr3uqzt1IIQUYL8wTIigku8l
        /LFYYcjz871pj40wS5yYD+Z2/0m3
X-Google-Smtp-Source: APXvYqwS3DgaAm4+vLvXAZ9Zeo7tempzemZdQsTbxW4zTwntlSTwtllhm6sBWPklubMkYQGCbwWwmA==
X-Received: by 2002:a17:902:bc41:: with SMTP id t1mr8526868plz.171.1565723683044;
        Tue, 13 Aug 2019 12:14:43 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id i126sm130247051pfb.32.2019.08.13.12.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 12:14:42 -0700 (PDT)
Date:   Wed, 14 Aug 2019 00:44:35 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, khalid.aziz@oracle.com
Subject: [Question-kvm] Can hva_to_pfn_fast be executed in interrupt context?
Message-ID: <20190813191435.GB10228@bharath12345-Inspiron-5559>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I was looking at the function hva_to_pfn_fast(in virt/kvm/kvm_main) which is 
executed in an atomic context(even in non-atomic context, since
hva_to_pfn_fast is much faster than hva_to_pfn_slow).

My question is can this be executed in an interrupt context? 

The motivation for this question is that in an interrupt context, we cannot
assume "current" to be the task_struct of the process of interest.
__get_user_pages_fast assume current->mm when walking the process page
tables. 

So if this function hva_to_pfn_fast can be executed in an
interrupt context, it would not be safe to retrive the pfn with
__get_user_pages_fast. 

Thoughts on this?

Thank you
Bharath
