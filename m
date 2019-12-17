Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE10123A2F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 23:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLQWsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 17:48:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38528 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbfLQWsI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 17:48:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576622887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9n/i9QgxhO0hGtWuQAcaruEVu8v3TGl7tcrGGNBkk0M=;
        b=ALfbLL7LqVea7auuoFdfHW9NGtLpKv4xKIdEYh0ree8Aa0fVJLe3ePm3ILRzOk8Aq2p6zA
        gcZk2crU1HTFJriyovdrPjyF/PJrukvgrc6ul9Ua94GtF9qrdXjvw/fgJFTNm2OUav8vX4
        nWAW2CLheFJ+c8i7Cereh5Y/37/lbCE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-b0ZULpBBNmWbEz66K03Cuw-1; Tue, 17 Dec 2019 17:48:05 -0500
X-MC-Unique: b0ZULpBBNmWbEz66K03Cuw-1
Received: by mail-qv1-f71.google.com with SMTP id ce17so170594qvb.5
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9n/i9QgxhO0hGtWuQAcaruEVu8v3TGl7tcrGGNBkk0M=;
        b=T8vR+nL9kS5bLrhlwBSy2xM9Epwkuyz/+Y8V4vXPHNL1KBZDyklt3uveevbM71inQ+
         5KVaN7daJBgWk99W5NtY8CMrAce8mPe9OjhDN87QN/deXUM/oAa5cIm1VQlLM7FhOtVW
         m3ErzMMPnRKfGPaHMj2VySX5gRMlRL/htqsA1LRELQHfoMFpPBn0/GHh3w4alKTkhVcv
         tNIYBQdPp3KZNtPMpYOykpHLXhWGDF466j+SlPSIg5r0ny0agdB8x5gOaaY/HVa/WXVw
         AR1/2XgBEd7hDxmYfVQuZcRnc/vaKhw4sDBWh2VFeIyhEWPHaNxD1FtNd8jactFgJCrs
         wm1g==
X-Gm-Message-State: APjAAAUUuhd4lKSLrB5jH8GQaYIMbE+qJF5ixDCbtOOevMcJGluVlsUd
        5fQdseCe0AqrHZDsuy3h0VWh6JwjRtgJ3UhiqdsLRJsgDRM9Ma9kI8zucLv5VqKK9PTz4ukhbN1
        pdjhM0rfn3L9f
X-Received: by 2002:a37:7685:: with SMTP id r127mr461136qkc.166.1576622885312;
        Tue, 17 Dec 2019 14:48:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzAlgi3q/A/lG8/yssi/9qke3Y+PomWjoA6OIsiWSdyH+oKnvcw0q0J4LOd+HEQncOFra+UA==
X-Received: by 2002:a37:7685:: with SMTP id r127mr461111qkc.166.1576622885122;
        Tue, 17 Dec 2019 14:48:05 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id 63sm15645qki.57.2019.12.17.14.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:48:04 -0800 (PST)
Date:   Tue, 17 Dec 2019 17:48:02 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 11/19] KVM: x86: Free arrays for old memslot when
 moving memslot's base gfn
Message-ID: <20191217224802.GA26669@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-12-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-12-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:33PM -0800, Sean Christopherson wrote:
> Explicitly free the metadata arrays (stored in slot->arch) in the old
> memslot structure when moving the memslot's base gfn is committed.  This
> eliminates x86's dependency on kvm_free_memslot() being called when a
> memlsot move is committed, and paves the way for removing the funky code
> in kvm_free_memslot() that conditionally frees structures based on its
> @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

