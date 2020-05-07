Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD181C9931
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 20:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEGSWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 14:22:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728294AbgEGSWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 14:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588875763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FTb6Jgxz0ykVKPeNAv5nqgXZUkMIvK3Ny3fqxRZnxuU=;
        b=eDeA8uMvkIJ7lrX073B9FUdXwaY6Jcvqte3/JkLCdKWsUIrHtQHmBx8QVd1+COQNG+UKtw
        ONOfoRZMQwKP6Cv0lXPDzEre9MpTdK7FlJvCgTdGD8YgNYRtET+1uzPW7YTqW24Lmq8vXD
        T2okfrJmA2sa4tNDaSvHMq+uMumSHRM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-UT9r_8w5PMi-THz42teorA-1; Thu, 07 May 2020 14:22:39 -0400
X-MC-Unique: UT9r_8w5PMi-THz42teorA-1
Received: by mail-qv1-f72.google.com with SMTP id r10so6520834qvw.23
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 11:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FTb6Jgxz0ykVKPeNAv5nqgXZUkMIvK3Ny3fqxRZnxuU=;
        b=RVJr5f7YJ5QqFj8vP68WymVLADTjQSk+B8qrVgrpffc6yMXFZpJu58ek019qFKpETG
         xQtTZ8GKpkSADQwrLU2Zw3adcTuuIYqacyHyOQf63wOBfTFGN65bIppLSYp2Q/2w25fK
         gJMH3WspH4guPI/7u72pSJ3ziwH73sEB2tbB+5oxhsRCYyyUW/TOGTSvbuDn3v8yEslh
         UvWFlJ7dFtsPg6XbA0aPCX7BJCDmFeluN+gLsI9wvIKYDFVgwoHuPWfSdaxqFinYqcq5
         bleRU/CM3291qF8X+ZZYt8hzmqkWt2tox2V7h+aQag1i+ZoCjcgoFTtvSPwCqxrvh9fD
         zH3Q==
X-Gm-Message-State: AGi0PuYtYSG7Qk6ZN8eFXCxNai6fd5URkoB/rTOfRB+hNVFZwo2a537q
        ClMciUXeC8NL7OXrDJMITsIvdvi2O6L1FPz6NMwlawu7bH3nVB8anEEYjqb4sa8O7N2PrrxthiT
        QPbOhO8oJtgUj
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr15208054qkb.131.1588875758748;
        Thu, 07 May 2020 11:22:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypKCifR6UPiWN6/+9wr1Tx/y5vkRfYxk4HrSwoCiBdTYmZRrhZOsFmvk/nyG88T+rRN1zCXWaQ==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr15208031qkb.131.1588875758550;
        Thu, 07 May 2020 11:22:38 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a17sm4857827qka.37.2020.05.07.11.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:22:37 -0700 (PDT)
Date:   Thu, 7 May 2020 14:22:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/9] KVM: nSVM: trap #DB and #BP to userspace if guest
 debugging is on
Message-ID: <20200507182236.GJ228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507115011.494562-7-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 07:50:08AM -0400, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

