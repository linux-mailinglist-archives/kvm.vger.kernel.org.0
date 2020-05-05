Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885D1C5892
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgEEOPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 10:15:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53659 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729942AbgEEOPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 10:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588688146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pdh8PaKKCB6jydt3X9bRNYULYYUuebIi6pG6NH9E+WA=;
        b=SGdpEVbPEAjN3SCEYVeQkqTns2vgKa79DxnAe2GNy5jhLHw8BozivequjrM9KX/z1f5VEu
        HXH2NExUKS1PZ7FXyWl423eYl2XSDT+9i4VPX3s1Ztj1WwiMq3T2HSXutQFwFUv3KCtKmM
        QUbUIMD3ckKcoQcwU2jT5bXBwGl6MSA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-iTqSL2uTOwm-TFSJArrWzQ-1; Tue, 05 May 2020 10:15:45 -0400
X-MC-Unique: iTqSL2uTOwm-TFSJArrWzQ-1
Received: by mail-qt1-f197.google.com with SMTP id g55so1776182qtk.14
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 07:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pdh8PaKKCB6jydt3X9bRNYULYYUuebIi6pG6NH9E+WA=;
        b=osT2VxiKPwgZ+fVYTJD1Nxhh6/ZnFGz85l77n5QhvbJ4sxv3R7gZnmJ/6B43vJrk+P
         peyonLMuj9Z7JW8XggrEr3Zgai35hyfN6KHDF7kIphrM4qhsOX9rVjmf6ogVbWsE27JV
         1p9NXJPaV+oDSXow1vJXYPukdO3Qr7C5THHwxiYmz8/vAlWkHf6ZiNnQBd4enCZhEdLb
         sTtSvOtj83DGqcoNZj8MIKy4oY6zuh5EjlGkKnkLyMte+ffP9sBbxnpvR4U3Keq31R8m
         PeI39kL1JwloO5XXZUp44nz5quJ0/n991+M58TuqCR+gf3Yp1P15hsW9ytQIwDvKXwC0
         +ZwA==
X-Gm-Message-State: AGi0PubdN+A47XAb097gl91LRPpUpFtmSRhbV/c1EDXYdsF3eff7R7b1
        /8omLhQEg4SE/e5QEkpTl6YTnj2i18SkfD+ItDJjpbpV/5mbnWOVRbf0UFxVMs9kvc+C7lBqaKJ
        sBAL2hBrRo5Hb
X-Received: by 2002:aed:3eca:: with SMTP id o10mr2829916qtf.30.1588688143991;
        Tue, 05 May 2020 07:15:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7Nwwnxis/I/GyVehDFWGlPcQsyscfxDqmFgtIZNy/E6RdlTN/1qONlWTO6ejDKf2kO4H/Dg==
X-Received: by 2002:aed:3eca:: with SMTP id o10mr2829897qtf.30.1588688143786;
        Tue, 05 May 2020 07:15:43 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h25sm1921298qte.37.2020.05.05.07.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:15:42 -0700 (PDT)
Date:   Tue, 5 May 2020 10:15:41 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [PATCH] KVM: x86: fix DR6 delivery for emulated hardware
 breakpoint
Message-ID: <20200505141541.GI6299@xz-x1>
References: <20200505113449.18478-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505113449.18478-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 07:34:49AM -0400, Paolo Bonzini wrote:
> Go through kvm_queue_exception_p so that the payload is correctly delivered
> through the exit qualification, and add a kvm_update_dr6 call to
> kvm_deliver_exception_payload that is needed on AMD.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I still think we could also change this in handle_exception_nmi() and
handle_dr() as mentioned in the other thread, but no strong opinion:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

