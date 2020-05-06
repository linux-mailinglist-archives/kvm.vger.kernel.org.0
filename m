Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE81C75A1
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgEFQBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:01:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729447AbgEFQBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588780907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z393CfivApjsVrwKlNbhxhzx0gces5Zy/3TksIJjQj8=;
        b=QFESgb9oIacBxFBMqlUhD5lgpIAmRlQG5IW1feb/tcqrz5gnONcEDiqBAfRWE6k1UWUzPB
        p0SOitMea5lk9vplnwLFbFcuGcisMcOf3o2bmbz8hfuPC10LeT5Yqw6g8PpBgrNvNG75Cl
        4CN81Kwr4HQcdPiUF3yGyYTYJfwO7QI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-JlS-5_MAOeSPGDV4yAyc_Q-1; Wed, 06 May 2020 12:01:45 -0400
X-MC-Unique: JlS-5_MAOeSPGDV4yAyc_Q-1
Received: by mail-qt1-f198.google.com with SMTP id z3so3295531qtb.6
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z393CfivApjsVrwKlNbhxhzx0gces5Zy/3TksIJjQj8=;
        b=awOWjd7PuViiRaMwOdtPihrziVNnMJwQgOJr+/OeULXk2XwjMow70e5ZsFm2OkN/b0
         MkHHJnBAFM9Z1Td7sr5+FHr2YMm+VcQAFeuTO5j7VH8gsxZO7l9mk4dZT1O3zLTwdWye
         Uh4PZHC/UMYq+YCz3nvYBZXromKIo21i1qC+sJr/aAs3fvk24BJtPBw7BPu3YDso7U1m
         EzxppyRuiXsTZoZXWahlku5HhLeWl58AwBnvAOIyoxyahMSD6TVVc4p474m6SgwMpqrb
         h4kmpWyO4IFAjHactotGd09EepXWNedspMU/aF3AGXvWWaHxUeayIFwGHZy3EUT/l7XS
         PjrA==
X-Gm-Message-State: AGi0PuasWMtE+ylV6iidyA56fs9Rh/A7NPzoOSH+fr3v3i3Y+yKKwm29
        DYH6bCcqkqrn/JAi6MMyRFBBdBUs2Og4ChgfCvp3livPQJnsQwDE41Qtq4rf3H+Ke8XZ9JiaIUv
        75b9jmghHasJ/
X-Received: by 2002:a05:620a:12f6:: with SMTP id f22mr6809639qkl.76.1588780902093;
        Wed, 06 May 2020 09:01:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLK+qF0S7SG5s1Ltj20QoKwPVXuJJsa1ak/ZLSXYyMz12MWdAozCj8NqzeHu9g3Ndi1bm7ALw==
X-Received: by 2002:a05:620a:12f6:: with SMTP id f22mr6809516qkl.76.1588780900994;
        Wed, 06 May 2020 09:01:40 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id g14sm1859729qtb.24.2020.05.06.09.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 09:01:39 -0700 (PDT)
Date:   Wed, 6 May 2020 12:01:38 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/9] KVM: x86: fix DR6 delivery for various cases of #DB
 injection
Message-ID: <20200506160138.GM6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200506111034.11756-3-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:10:27AM -0400, Paolo Bonzini wrote:
> Go through kvm_queue_exception_p so that the payload is correctly delivered
> through the exit qualification, and add a kvm_update_dr6 call to
> kvm_deliver_exception_payload that is needed on AMD.
> 
> Reported-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

