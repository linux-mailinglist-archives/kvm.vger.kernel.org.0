Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4582B0C82
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKLSX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726221AbgKLSXX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 13:23:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605205402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QWByVSqR+09ObdKY5uGyCp/I3vWyhbVdQY+MRTdKDvU=;
        b=CPh0iHs4m8ZKvGhhz6pvtweE9kUd0IqxxXeXqo9oH6sgNOxiV8j7RZIAh8R+QVgYpCOnnk
        w6mxnXKx90WQ7dXpWStM0lKuhUyD3IDQ29ZZ98X92Pyedk8qK2LCPUr2HGQB4XWzJW+i0w
        8q5rcHvC5rhTWSUbB9pHFVYeMzKSFWk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-50uNzzS1P3iRyH8JUVNMBw-1; Thu, 12 Nov 2020 13:23:20 -0500
X-MC-Unique: 50uNzzS1P3iRyH8JUVNMBw-1
Received: by mail-qk1-f197.google.com with SMTP id x2so4832026qkd.23
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QWByVSqR+09ObdKY5uGyCp/I3vWyhbVdQY+MRTdKDvU=;
        b=kdLgJvuMuM7fPuNW7x852UT8ZPcGtw5hCc5KIMe4qWtvtWc9yGycZXxTGiJ2PZ3Upk
         2eu5FrRjn7Yb2bM8VglUbtbJjg0jY0GgntvJjqCrqPCI92Q0HThzlL2GkS/zJrHuht5z
         3UNg7ZdjOY4n5cqJNRmsRiRCR6LK8eTbYhoAH1vNBcdglEHV3ngqLatZegAZNIn0Kuva
         p2QjPI/lYNiDHg+1TQP7hGGojS9JgLcZKBDw8kIfMXM0Xz5zjq7DmY870r6PZD2muCYY
         Sc5SlPpOLCrXIUOqTitAvbYyAs3OLyfj8Byc/4XJwIY6dyzJlvXYANG6b+kuiZroJnBI
         X91Q==
X-Gm-Message-State: AOAM530KeM6wt2CGMv0/WDqbE616/egrEf2PziMhdN+f0JfdnfU3iYAy
        NCjHbME7OluujXtmozAf8gYUp9+9bw+28MQFGcxlK4BHxVz3IE5ehhA29wcrZGBc7pYyXvSe/BM
        ccr5mxPPOERR5
X-Received: by 2002:ac8:4d99:: with SMTP id a25mr476681qtw.122.1605205400401;
        Thu, 12 Nov 2020 10:23:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQXcggqCKAmnR/nKj+cCnYUqoCLdbh/Y+ZFrSrgLgkp6d0+OzZ7a6EQmdyrMBfq9xn+8udpg==
X-Received: by 2002:ac8:4d99:: with SMTP id a25mr476667qtw.122.1605205400222;
        Thu, 12 Nov 2020 10:23:20 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id r19sm5010921qtm.4.2020.11.12.10.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:23:19 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:23:18 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 11/11] KVM: selftests: Make test skipping consistent
Message-ID: <20201112182318.GX26342@xz-x1>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-12-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201111122636.73346-12-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 01:26:36PM +0100, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

