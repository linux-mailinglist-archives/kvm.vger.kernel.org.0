Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA3305C09
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313975AbhAZWvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbhAZWDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 17:03:21 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE267C0613D6;
        Tue, 26 Jan 2021 14:02:33 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id 19so17623281qkh.3;
        Tue, 26 Jan 2021 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gWT03kNJZSWxacIeOv6hjkOlCv2pmh2+pjFjp7VWYGQ=;
        b=po/4EBxBrPQhQy3bPcyEACcYckHeCx+IqagN9LbPD7QWla65XueTFcJcZhFwMJm5q8
         BkPgq90SfW5XB9q4rUfFX6Q3vmRMiuNukJ5gbVAmZ6/0QFvGhiqd98fNfF72QI9cj0Ts
         3ogXVPNT6D3/2J0imMFB6/PEl6R35PvlqLRm2wFIoDdw/AXQE2G1hGL40IY+DVMULxmi
         iCBTlotIA6yDRSNo6CTMqmoQCf0qIGCKYk7YpRU6ooc7Jioj0XEHtleX5dUCur8V8pdh
         ihHDES1CmXI3fZis+DWWDI/VKa2rTH87g2JqBhjS1rzTSOWi+/XOtRg+At/G2P5QzXzb
         b1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gWT03kNJZSWxacIeOv6hjkOlCv2pmh2+pjFjp7VWYGQ=;
        b=OPfrGCAlYZ3e1Ux4tpeF+uHipjpOn3Pirdq7EWpp4JvmSAkJ/6cGWvb8dfqug+zJAH
         S2ZK7GnjhqS/8bdCd/2X5iX4OXH40R0NrDC022f+3mVCMJHmOTl0hQeZZo11VrG7VPNj
         iwWNl2naKWGPi3oGQfZYhTxpTaEGkMjDYxAhgUu/wNtJFyTDZYbidl2pjM5FXLfkDZzL
         UFLk+ZE6P1a05gIx+YWV0TLAc4Yz9j9od6TOhlANR2UP5qr81n5W2NdVe58RRHfScB5L
         a0t192iNGNqjgxb8lTpo/z0K/TTQV/BBCsRK4mMDhiaa2f0A0t/EB3YHjO8TUEyjXt8x
         PqLA==
X-Gm-Message-State: AOAM531QRT0pkHUC6kmIn6H/fvDR1DrB5hg72ur7dCmO6nPP6ZCct8Iy
        oSnANSnedkhHBpWlMlx/970=
X-Google-Smtp-Source: ABdhPJyyzX85Np38HsoeiXjHBOf7r59tdlimvNL993RgQ0jIX8eXag45KCmHYtUXT1OgHmK2eEYcjA==
X-Received: by 2002:ae9:ddc4:: with SMTP id r187mr7793968qkf.391.1611698553042;
        Tue, 26 Jan 2021 14:02:33 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id o15sm32861qtp.51.2021.01.26.14.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:02:32 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 26 Jan 2021 17:02:32 -0500
From:   Tejun Heo <tj@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
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
Message-ID: <YBCReBXMczop/GQO@slm.duckdns.org>
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
> * misc.max and misc.current: nested keyed files listing max and current
>   usage for the cgroup.

Keyed files, not nested keyed files.

Thanks.

-- 
tejun
