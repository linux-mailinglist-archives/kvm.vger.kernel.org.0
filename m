Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200D7305199
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 06:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbhA0EY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbhA0BZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 20:25:19 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E9EC061786
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 17:12:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id z21so443370pgj.4
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 17:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h4YmZOf34leeTQFI3eVZ6RKnokT375TaRDpu5h/uKr0=;
        b=C22G2NnLTkRdn/mttyEGOMoXxuTI2raLaGT4eCAOpNLzguJMhhMmlz0hxMQ5gA2Rj9
         qTOfsm8D9kYABK9iahC0LW6TJZGFYlNTBRFUajK7C0nvPhjSPfRyPxrSld7uQxz5yEPk
         8gOyD6zIHU7KjQD4jKwUI3I0eCeE4pQBotxDMRCpTJ3onB6SaWW6YcvXP1A3os4mkSh+
         ZWrMmw2P91GRl1Zfse3yYl0EuS7KKt7X4SpR8JphUOejt6zAT3zvjROsAJ8vux6lw3Tb
         YXzV6lDO0Zfg+oWDaGv5DDtrpWLiCpE/+MzqEQ1j9jOyYE+FHvZUTvAXPton0sk+fASu
         ZqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h4YmZOf34leeTQFI3eVZ6RKnokT375TaRDpu5h/uKr0=;
        b=FHXLw3FB4sjB4ODgJlzrBTL4oTBaFqfWNwsR7BayR+bBDA3MjFRCpuIcyKC4wz2+a7
         GU/jvsX0pUV+DqTn4pWK8XYxsJKAiTF/ELkE2r8GGff89fnfHNMkHBN/GzVteU0w13GH
         C/JloHOxyCwihj5caIW+BmFcXQyAhdHB43N6xw8+L1aizeLsiVEaWjYfbpmDIhv9BxN+
         UBBSzHfeWQa8QBP8zxL04Lf2hQUlqV9pw4zLiAVn5VPH5rjdvzc0ZsgQ1M8ddbCEcZXb
         5wuKq4BrteypDBNovFHqRzlk4JuiqmIAER9ze5HF95KfYj1m7HuqN0Lz2Vlp4sK/WOYY
         lYWQ==
X-Gm-Message-State: AOAM531zhBGl3bGwPaLzmMYZ4VzGzg+GBRzggSExi3YHfP7WTlglwDFT
        x/mnK9ZSKTf6Yf8KnD44PTmUcQ==
X-Google-Smtp-Source: ABdhPJyEFpCKvCKNjaSTTtBB/neKejTeHgWHIeRI3pSHLk8JaIe8gAIqZfxZc0fdfHzlPPO0ubyR3w==
X-Received: by 2002:a65:6895:: with SMTP id e21mr8328535pgt.240.1611709924537;
        Tue, 26 Jan 2021 17:12:04 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id gx21sm136854pjb.31.2021.01.26.17.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:12:03 -0800 (PST)
Date:   Tue, 26 Jan 2021 17:11:59 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>,
        "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YBC937MFGEEiI63o@google.com>
References: <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
 <YBCRIPcJyB2J85XS@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBCRIPcJyB2J85XS@slm.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 05:01:04PM -0500, Tejun Heo wrote:
> The whole thing seems pretty immature to me and I agree with you that coming
> up with an abstraction at this stage feels risky.
> 
> I'm leaning towards creating a misc controller to shove these things into:
> 
> * misc.max and misc.current: nested keyed files listing max and current
>   usage for the cgroup.
> 
> * Have an API to activate or update a given resource with total resource
>   count. I'd much prefer the resource list to be in the controller itself
>   rather than being through some dynamic API just so that there is some
>   review in what keys get added.
> 
> * Top level cgroup lists which resource is active and how many are
>   available.

Sounds good, we can have a single top level stat file

misc.stat
  Shows how many are supported on the host:
  $ cat misc.stat
  sev 500
  sev_es 10

If total value of some resource is 0 then it will be considered inactive and
won't show in misc.{stat, current, max}

We discussed earlier, instead of having "stat" file we should show
"current" and "capacity" files in the root but I think we can just have stat
at top showing total resources to keep it consistent with other cgroup
files.

Thanks
Vipin

