Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749F1484F71
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiAEIjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 03:39:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232301AbiAEIjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 03:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641371950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xfdbcsWE6WpZBXvisiAH+ls8mCAIddVJVvgbPB+PRP4=;
        b=cvZErq6R8ILpamNO9NTlJTBkdnceU/2wBG/ZCLmCe/VhohxM8Vn/NSuNXntDnQODVI2Osb
        jToKpBcgkeKv0CBdsPJjfHD9xVzDMtdHt8VQh33isK3Lu5/1ioYYGyhFHrbtqJmBlNIv2U
        t7tL/fAzMAcHqVyjiBUXHJjxhtxRnXM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-XLtPjOplMByfOlHo1X88ug-1; Wed, 05 Jan 2022 03:39:07 -0500
X-MC-Unique: XLtPjOplMByfOlHo1X88ug-1
Received: by mail-pf1-f198.google.com with SMTP id j125-20020a62c583000000b004baed10680bso20036467pfg.2
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 00:39:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xfdbcsWE6WpZBXvisiAH+ls8mCAIddVJVvgbPB+PRP4=;
        b=TBrk3gnFt7f/hMR/qH2WH2jMm+x6zl7YVLIRXavY/auO43sMsy2rK8c1tO2D/pgHcH
         tq2viCjLic/vGp/0HSjcecbJZ9tXomO8lUTmhsTy7QdkBe76jZsmoqKJlrIMPK8jfRjp
         leb80sS2i5Tw9bszN+SI9DzItRW97CPJTXE1R/gz1Urqvp8R2F7KMWzSRSbYZoYByL4h
         DRDK67uAHeE3drVkOWEh3FUraxEIHRkta7ry++ActfQH3uPiaof+JVpIVC0j719yGpvV
         V/53DUNAePkWyEw63BifIvnLiYrjduAHcLh2+QA/eqJQ8aKcPIZyPNRAyy7pVLARYv8y
         r5FQ==
X-Gm-Message-State: AOAM531FQFdwvowhRhWX4WascbKqJbWNzDMiIKgqaP8eKYae6cxG/lhY
        LfDcekRXW+rwjDhggnpB0uVU5RFJLkB8yDIEikB7YeGY4PHB8YzjYzShfiH4g0ZF6/Snd8QUTpM
        GxQFsKYxDKfDt
X-Received: by 2002:a17:903:124d:b0:149:8141:88ea with SMTP id u13-20020a170903124d00b00149814188eamr39172818plh.82.1641371946613;
        Wed, 05 Jan 2022 00:39:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypQt49ZcKqwUqHXZDVj6ddyDqssoniL5+aypgiq5CcT++/CT9btvSCJdC1pJZJrxz0Y/FlRw==
X-Received: by 2002:a17:903:124d:b0:149:8141:88ea with SMTP id u13-20020a170903124d00b00149814188eamr39172804plh.82.1641371946418;
        Wed, 05 Jan 2022 00:39:06 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id t5sm35527042pgj.85.2022.01.05.00.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 00:39:05 -0800 (PST)
Date:   Wed, 5 Jan 2022 16:38:58 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 13/13] KVM: selftests: Add an option to disable
 MANUAL_PROTECT_ENABLE and INITIALLY_SET
Message-ID: <YdVZIpExqDCO6lcg@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-14-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-14-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:18PM +0000, David Matlack wrote:
> Add an option to dirty_log_perf_test to disable MANUAL_PROTECT_ENABLE
> and INITIALLY_SET so the legacy dirty logging code path can be tested.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

