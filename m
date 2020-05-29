Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349D81E7763
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgE2HqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:46:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43645 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgE2HqT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 03:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590738378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7bp9K1xQDo+AhoH9e/7SQpViLsmuixXQeTMU/HkuiBc=;
        b=FYNphAZ3oZFqHy1YK3xgCxCxRLonqdcqkNBxYTX8Hq6XQGadwc5EwNmS9nR4fpah+5dQ6s
        h5vCHgPiWqDUEHKURdARCbCQtGGkAk4M2RHCYZFu+pUmWh9HfYcq0jHka1M1Sh58FotP2p
        W8326zVXUr+Vj5GZ3cAk6uehM67fMVk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-TMw04soZO727ZTmLH4l6BA-1; Fri, 29 May 2020 03:46:16 -0400
X-MC-Unique: TMw04soZO727ZTmLH4l6BA-1
Received: by mail-wm1-f69.google.com with SMTP id l26so364517wmh.3
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 00:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7bp9K1xQDo+AhoH9e/7SQpViLsmuixXQeTMU/HkuiBc=;
        b=jj3W5yYAkhdLscq7O8mfTquSe7FQ2C8dE6GpWTVb9umsRrK3p5SHlVTeEcqRcD4015
         3aozlZLr8HnBw4A+TbApL5GjphLmYpe4UW/4pLmZ/TRJmLP6yVgLeW3pOwt6sFK82088
         7Rqqpuj2RwPuq5e55e/NiBWeejQtxphcgT50nNriGsz3E8ulwAGUdnD00rgylRvhJlT7
         ak1DmNDGe2FTGBp5+6qMPKg+KskTBryFfjy/kC7y+crJ4KuLhYIJIAjBHhFkKrY0uWH6
         BEl8CRvmTVOS2AipzRFp1LCEXsrwxX/ECGIzcb90xRpxopMVqIMv9x5+n0KeDkdZ5OA2
         khMg==
X-Gm-Message-State: AOAM5305Rzw3AZN8tkKCnr8sGtA2C+MXLmT36Vmbyc6IQUtEW5/IvsL5
        uIow0CaJKpJIl899JLEwfcqZy1gVD7gCjMz8se3e5GOnqyjq2hCAX6VESci7lFecYgo8VzXAm1n
        q2ipjJjmIfjum
X-Received: by 2002:adf:e44c:: with SMTP id t12mr7073398wrm.181.1590738375682;
        Fri, 29 May 2020 00:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhI05ctvDPHmK0GSn7jXPozth0v0wonOshy3raxVwfo1HlERJb1RrSppYq/7L2egaQSMLAgw==
X-Received: by 2002:adf:e44c:: with SMTP id t12mr7073381wrm.181.1590738375477;
        Fri, 29 May 2020 00:46:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u13sm8796062wrp.53.2020.05.29.00.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 00:46:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
In-Reply-To: <20200528194604.GE30353@linux.intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com> <40800163-2b28-9879-f21b-687f89070c91@redhat.com> <20200527162933.GE24461@linux.intel.com> <20200528194604.GE30353@linux.intel.com>
Date:   Fri, 29 May 2020 09:46:13 +0200
Message-ID: <871rn3ji9m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> I'll looking into writing a script to run all selftests with a single
> command, unless someone already has one laying around? 

Is 'make run_tests' in tools/testing/selftests/kvm/ what you're looking
for?

-- 
Vitaly

