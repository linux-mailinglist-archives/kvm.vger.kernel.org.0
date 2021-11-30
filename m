Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D23463F51
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbhK3Ufq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 15:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhK3Ufp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 15:35:45 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3B2C061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:32:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id j11so11197017pgs.2
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 12:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B+eD0AWbPxjSOvumJqLuOeGMxfPK4HMsAqhFNdXov90=;
        b=Y8unY17G21VVGtvXgLMaiTe0aRZDMVmNcBpHL5Tvibr0/N+lPkYqsBLYBHPo/MIV4e
         IjJfBocLcZ8PH46WvEexLvilRwexBuHTHF6CxXQ8gLDCHByzmptGoDcDUNYF1Yk1GfRr
         0VBAVBc6jRiVRKvHTqfSnJgYMXT0jrBt2f+Q+zX1JdO5GbeRMKVn4xEQocSXLQZuSlA4
         DKqlEvUadJ7ueEQcLaIkJDNMPlYU5EcniJkUmdFLaICbUQyTzUgQI2iGxNsTwmymudOL
         /HFnxJc4vHCryD1Jouh6CPw/5YOsJiStegwB3MT9HlAtj/I4tAN6Dtvkn6CbuS6gwGH+
         0Mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B+eD0AWbPxjSOvumJqLuOeGMxfPK4HMsAqhFNdXov90=;
        b=S3kS6hAyB7ulrVX/yuBpkIxK2mDGwI/n7fOPQsi39fMmkPgChzV3YB28DlvgZEK1kd
         wcJfpzkfhkW8DE6J/8etd2WldOLrfl3alyu9K1hfB16CoKCSgm9rU74sZZMuLzke52c7
         /kk1DwEMnVH7oMdTY5rL+VUFXGVZ2up8Y1+DvaLcB2bzip0I6MM+tAtjhuXhtvKup84p
         2bHi67WfxYAf5zOnsAokGCSoVuOxxku+sqmcCQjFyeOeWdXeKRDkpLjelqMcH/WmvJ8n
         +TQL1R3aP5gjKlPryXylDclYL+6ciMgD0ijHptCsYcFlw7B6WBaWBeTfzvJdEz8k1gPK
         YTYA==
X-Gm-Message-State: AOAM531+d9KuQJ5H/ZJYvoMihPppW25KyWi601wdkpgJIVxsSL5xI8XO
        ubUrjnydnh/N3AWcCG9ZjUfUcw==
X-Google-Smtp-Source: ABdhPJyofkir993EDxQcwXyX/oKLHP9Wy/1ZcLGZ8iP3L8T645GoCvVeVd/SxI0QHz4G0sZTSCBcDA==
X-Received: by 2002:a05:6a00:1305:b0:4a2:75cd:883b with SMTP id j5-20020a056a00130500b004a275cd883bmr1630196pfu.44.1638304345435;
        Tue, 30 Nov 2021 12:32:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q1sm22754763pfu.33.2021.11.30.12.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 12:32:24 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:32:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is
 disabled
Message-ID: <YaaKVYnM2hNfI4J6@google.com>
References: <20211130123746.293379-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130123746.293379-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Paolo Bonzini wrote:
> There is nothing to synchronize if APICv is disabled, since neither
> other vCPUs nor assigned devices can set PIR.ON.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
