Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9E153B46
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 23:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBEWsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 17:48:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbgBEWsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 17:48:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2cHEFoE8jbw7EqsKmYikm9pxnEO2ox+NzDcqYlTv6MQ=;
        b=Dj7Z1kiw7G/PuuORGC6/83jHx8OKLoMVTjR+Kln4WbZUsanr+PcUJFBjdokS+n3HOyT+ql
        Gd8elekGmu44iFXXCyRSal/OLx1pteXsxyNJczGZGlajl5vMRdlhllflQhw+nP9Is5Nsy/
        uwUh1UDCd7Gb1PNrQ9S/HWzvYzi87Sw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-X2GZDkCiM7moARKqqKPVTw-1; Wed, 05 Feb 2020 17:48:13 -0500
X-MC-Unique: X2GZDkCiM7moARKqqKPVTw-1
Received: by mail-qt1-f197.google.com with SMTP id e8so2479049qtg.9
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 14:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2cHEFoE8jbw7EqsKmYikm9pxnEO2ox+NzDcqYlTv6MQ=;
        b=V/ebN+RKdqABXnBryidxMSVE1UAJ2Xkt6EmwNEnc6GHf0KI22R+wHwbZAJ4Vg5HgrZ
         oqp///8dtZIeSZIieWlvHtTRLhe5DYCVyrshlsmO8LhkujZPUn6FhKgdk18vER7Bzot4
         NoyyFGPJzh10A4Og3dXD+7GAHby3bgF4/pWcpHN0nL5cbjIGxJvk0CVSG+rxFVcWgHZ8
         zW7YRXBYbsdChJWv8AMgeVVSxsg5jzbvsrpLABMXLH3dHoVsfv3V98l9nxIiFxWdNHXl
         JWGAxUppi7vFyk+pfUlVkjGpSYc39dYmvpeodW1+onmJ95lgVZZAWV4daEW2SGaI7wfq
         ARbg==
X-Gm-Message-State: APjAAAUeb79JkF7Uca5WlSVB59BkFvD0D8YKhAUww2pK5KSi2gLS2m0w
        93xzlC35+vZTMo5cJIrNejn9sqD5GCLjFhUU6Ahal8P91+no015blsBduBRQjOLl6QUj57GxLhC
        DQkEXQtA/2BN7
X-Received: by 2002:ac8:718e:: with SMTP id w14mr82089qto.266.1580942892809;
        Wed, 05 Feb 2020 14:48:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzidgvMzifyXKMl5xyBUEvf76nUThQJ4Vf+I9H3f+5mpj/6PKciWyQRPVlUWOeD9yt6R/onsg==
X-Received: by 2002:ac8:718e:: with SMTP id w14mr82077qto.266.1580942892562;
        Wed, 05 Feb 2020 14:48:12 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id s67sm562392qke.1.2020.02.05.14.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:48:11 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:48:09 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 08/19] KVM: Refactor error handling for setting memory
 region
Message-ID: <20200205224809.GI387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-9-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200121223157.15263-9-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:46PM -0800, Sean Christopherson wrote:
> Replace a big pile o' gotos with returns to make it more obvious what
> error code is being returned, and to prepare for refactoring the
> functional, i.e. post-checks, portion of __kvm_set_memory_region().
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

