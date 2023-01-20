Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208CB6748AC
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjATBNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 20:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjATBNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 20:13:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE19F3B5
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:13:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id jm10so3969982plb.13
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=54Q/TlzbS+DFwNiz661U1uDBhYOWMskoME6kXhL4Rqs=;
        b=HLXf297OXlmCinyIsALB6Gl5jSu9aSLUcLlqBBsQ+Yosm7cWWS3QTFqHqRsM7VRhNx
         VlZE1a4yxahq2EeVVG8m0U0BmXEfx0sjbQ9W1xoiOffhHuWz9YdaoVerfYqYBvjKhqQG
         pc8bbcriyiWhtvqxwaGPgKk3KHYmi5krB1WraueVzNSTMbqvAU2FaSmgwYzFw8F0pqU9
         9/T8LKYBfX0ZIooNoDAWAMC5V+CfeIGZ2XfGLuyyLISBsbnKXF9bIaQpIeUBwb+8xvsK
         r+RRECqQ7EPjL7QJ3qB49f2zigxwwey9Qj0So/uCGbNU6Zs8n26H5LqLc0Wa0eVczYAW
         fdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54Q/TlzbS+DFwNiz661U1uDBhYOWMskoME6kXhL4Rqs=;
        b=Rzsp+AZgFfmXbDLQZcMjF5xweOMVebNq9vrNOgA2Jijacj5QM1r59pH7n9YjTUcLg6
         cYuHZFooL3BZzUhYGo25nUgGhrFmk1mt0me4M5YK1TQjAsLKJmCKA/ZXhDn5YUZqPBe5
         WQOEo84mBhkAWNnOtIyabrBx1e8wcYNvvj7o4YyqhOZO4q5/sa/FAhrbOWN5q40bw8ik
         qd3zvcqp0m9EPFW2IL/xEpWtlsst/K1NBxjIFmI2Ro7PSdlKNG2l/HFvHypDCsduXeWM
         fgPhJqNjkyAb7HFwhJPseR2M9ok4g5B2agYF/39LJCbVCtv9nC30hRdv8A+fHix9KgYx
         Xz6Q==
X-Gm-Message-State: AFqh2kr6Efg34JnSsq/oWTbQDkUBzCawUS/4HqXm43KtMyj2GrFkXp3f
        gqvQRERn0fl316EqD5GyagtNhg==
X-Google-Smtp-Source: AMrXdXtBmKBoO8bveVA2cTRXrVxI82YkPJo/ltKfaMri16u76lDIMUNYKkiKDLzuUC/IwLzTgxJD+g==
X-Received: by 2002:a17:903:304b:b0:194:d5ff:3ae3 with SMTP id u11-20020a170903304b00b00194d5ff3ae3mr4716pla.2.1674177219960;
        Thu, 19 Jan 2023 17:13:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b0018c990ce7fesm25677780plh.239.2023.01.19.17.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 17:13:39 -0800 (PST)
Date:   Fri, 20 Jan 2023 01:13:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Message-ID: <Y8nqv9K/WUqhaBub@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022, Like Xu wrote:
> Starting with Zen4, core PMU on AMD platforms such as Genoa and
> Ryzen-7000 will support PerfMonV2, and it is also compatible with
> legacy PERFCTR_CORE behavior and msr addresses.
> 
> If you don't have access to the hardware specification, the commits
> d6d0c7f681fd..7685665c390d for host perf can also bring a quick
> overview. Its main change is the addition of three msr's equivalent
> to Intel V2, namely global_ctrl, global_status, global_status_clear.
> 
> It is worth noting that this feature is very attractive for reducing the
> overhead of PMU virtualization, since multiple msr accesses to multiple
> counters will be replaced by a single access to the global register,
> plus more accuracy gain when multiple guest counters are used.

Some minor nits, though I haven't looked at the meat of the series yet.  I'll
give this a thorough review early next week (unless I'm extra ambitious tomorrow).
