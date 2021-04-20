Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F0B365B4B
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 16:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhDTOiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 10:38:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232597AbhDTOiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 10:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618929463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33CVA8kWHawipps7EFzUJb1CXaHeSH20T2baV3pWy8g=;
        b=eawdI7Re9axqPZW5ClbKilu6mwYpkoVMvInu8pJzFsE/0fNWBYpGDhz/rUUlWOdKpbE0lE
        PHwsSqsnNQO0VamlFZeoQJ8egM/jX7TVEdsPP5ZMU35I3+tuADFJvLY5eN6D1rVSv5/MUI
        a37C5rtAZff2X1i478P7UGHeujXjyhI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-t9J_ocBcP1SMzj4jTelMrA-1; Tue, 20 Apr 2021 10:37:41 -0400
X-MC-Unique: t9J_ocBcP1SMzj4jTelMrA-1
Received: by mail-qt1-f199.google.com with SMTP id g21-20020ac858150000b02901ba6163708bso1375527qtg.5
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=33CVA8kWHawipps7EFzUJb1CXaHeSH20T2baV3pWy8g=;
        b=DIm7ZVg3inCIz9ZvHxBgEKauu+7QxHNmWb8mk6Fy7gNIVgsXRt60eeqMBcrTpPRiYh
         4tuUB9BFG9qKONqq8l4E4xXDXrwL1YI2T68CpgF85P0VB2qGAVeJAySkZXR6UeFDMXfq
         /KZvMo5CqLO9oJyltlbKH4k8kMwbd8qTKA784j3Q0JG3JKumV4ktj/8+1+9UlGl3SCIv
         jOuKc2rlanMK5Nnp1cKMy1CjFcZoK0HhJjIaUH40NjKSQmZdUQ3DSARA00V4prlMateH
         cp0P08FWSboP47G7ypPZiShOKMyahQ2SPE6gfT9HrTAlguKJeQXxkwj2De3ZBkk+c8Zy
         b3dA==
X-Gm-Message-State: AOAM531qXgeudLKueZZgl8//47wNjRyaHjKdodTsZ+DBezamJCS1FANV
        1p3PjPbjm2CymI1M3ns3qeGAGnb1R3fiWNCtOXEGnvAO0c7C/4tlB+p2YCfhjkMZze1xRBW828F
        Jv2TNpw5+FnOR
X-Received: by 2002:a0c:fb43:: with SMTP id b3mr12120016qvq.42.1618929461411;
        Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4ONXVSlwHL519fIegDGFnXVnOOob94nUlZsSOdtHzcOFxIJiOusGtNuV+XRpmmYe1+KUq/Q==
X-Received: by 2002:a0c:fb43:: with SMTP id b3mr12119998qvq.42.1618929461181;
        Tue, 20 Apr 2021 07:37:41 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id k127sm12216745qkc.88.2021.04.20.07.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 07:37:40 -0700 (PDT)
Date:   Tue, 20 Apr 2021 10:37:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
Message-ID: <20210420143739.GA4440@xz-x1>
References: <20210420081614.684787-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210420081614.684787-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
> The main thread could start to send SIG_IPI at any time, even before signal
> blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
> blocked.
> 
> Without this patch, on very busy cores the dirty_log_test could fail directly
> on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
> 
> Reported-by: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Yes, indeed better! :)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

