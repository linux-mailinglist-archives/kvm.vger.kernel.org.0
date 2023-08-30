Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5298D78D0D5
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbjH3ABd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbjH3ABF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:01:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50F11BB
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:01:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5694a117254so3103349a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693353660; x=1693958460; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xgz0GVD0FwMUGkbfqhn3uEmN0gcAW46U8UB4yCZTGQ=;
        b=JNlqxx9nnqvQc5RaLrG8D1uZgoSnh24nMuxn90KUj/TcKx6fhIQDAYSgvNz+KVEYQv
         G8u59ud4Mzyi0w37TtL6vzMpKMP3Eoln0qc5/4WdbsvRilHwoT0qWMb4CheCe0Y6o+w3
         307BKJ2fRpa0vKAeoJRWO5Cq5TEfA69o2oEcXtu9390sG5gGq9a2eP+bJH1z/hNhLtgN
         V7CNcKURlwIDBSAA8V23BNjmiMkSGKkZQrBEGbiPyJb0nlNtSJmw/A88q9s7kZtuwWGy
         87LdjFGqFvfmeVvQ0b6FyxJZ9/0hP0Du2Hdp5mRGToHDvggueoTPcEci9e1sYIuH8bsW
         rsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693353660; x=1693958460;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xgz0GVD0FwMUGkbfqhn3uEmN0gcAW46U8UB4yCZTGQ=;
        b=l20APU/STwG98n1ktinLCys8Q5u6zyOsl55CBpSQDisGDwn1jOU2UVD0oo7+odhPyG
         fbmnKwvRin8draLtsEAV+AOWOvh4sRRYGSgFQjLtrAjyghJQ5kVoh/KNr+XK96z0vHLe
         FByDal7481C+Gqce0BS33k7ojBvcDwDNYzc027MuwGBbFbyTSkn52HDjtcOGzh34seR/
         jyQ0AEf0laHydnu5xb9aKjnoa+av9Q15ai+nleKMpxFADb9yu3hCpjg+pQ778wvTBuwZ
         m/r813rPoI3hcWlXAie59K8c35MQKwlCJZpA3KSQv9ZNehaWWLVjj0Kq+C4YKbOY0ykD
         XYsw==
X-Gm-Message-State: AOJu0YxX0DMuAsuFMUzS+ik2FY1WTOiGOUZvyZXd1IzH++NyeGO5ZkTc
        HYSVmPrNhdrOje85eefjvHo=
X-Google-Smtp-Source: AGHT+IGVjLlx6E7hMW08/z8+i7YtUNFPJLM9zEH0D+FSMR6jqdOe9AgautqOTe4a38nyHcym4UJDvQ==
X-Received: by 2002:a05:6a21:33a1:b0:14b:e383:d141 with SMTP id yy33-20020a056a2133a100b0014be383d141mr1029313pzb.34.1693353660336;
        Tue, 29 Aug 2023 17:01:00 -0700 (PDT)
Received: from localhost ([2601:647:4600:51:cfd8:e566:eb63:a281])
        by smtp.gmail.com with ESMTPSA id n26-20020aa7905a000000b00687375d9135sm9002698pfo.4.2023.08.29.17.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 17:00:59 -0700 (PDT)
Date:   Tue, 29 Aug 2023 17:00:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
Message-ID: <20230830000058.GA1855290@private.email.ne.jp>
References: <20230718234512.1690985-1-seanjc@google.com>
 <ZOjpIL0SFH+E3Dj4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOjpIL0SFH+E3Dj4@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 10:47:12AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> kvm_gmem_error_page()
> ---------------------
> As pointed out by Vishal[*], guest_memfd()'s error/poison handling is garbage.
> KVM needs to unmap, check for poison, and probably also restrict the allowed
> mapping size if a partial page is poisoned.
> 
> This item also needs actually testing, e.g. via error injection.  Writing a
> proper selftest may not be feasible, but at a bare minimum, someone needs to
> manually verify an error on a guest_memfd() can get routed all the way into the
> guest, e.g. as an #MC on x86.
> 
> This needs an owner.  I'm guessing 2-3 weeks?  Though I tend to be overly
> optimistic when sizing these things...
> 
> [*] https://lore.kernel.org/all/CAGtprH9a2jX-hdww9GPuMrO9noNeXkoqE8oejtVn2vD0AZa3zA@mail.gmail.com

I'll look into it. I suppose we can utilize fault injection(Linux kernel or
ACPI Error Injection Table). Anyway we will see.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
