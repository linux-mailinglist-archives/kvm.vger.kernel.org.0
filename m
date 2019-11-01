Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723FBEC534
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfKAO6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 10:58:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbfKAO6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 10:58:52 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F4DD81104
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 14:58:52 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id l184so3633463wmf.6
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 07:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u2CxMAivUe7dZm3320bhIQ9Xyr/AwoYRD0bvKrh5Kn4=;
        b=Trk6jqMIgcEEkpvqhhVLUecNniJwfDUB+riP23r7Ln9JKoLy/Y+yWXz9+igCEnpQoY
         9r5L23k9zLcbVjobGW152SqOtITKsNMPZFvUW9bA9bVIZUNqQL8mXIqnmehm+pQPHlXu
         RgKOPWTSlhx2+TShZeVQs6mmdJlmRNENDImDuW/HOyYUasVg7WbzVVhrLNFHXM043/I3
         MO5aUdI9T0BkYl+9LzkrUSZfTgNMzMLSx5uNv+IDZYcWhExi3F7pAoFKGAplTdh5xlyK
         UmPGKzUdqxZ5HDksCAaMY8F82Wq844u3nuwDaUbIS5QsNXP7H7nLrzLubyHsQcPKd3So
         TBKw==
X-Gm-Message-State: APjAAAW19ePZcs23axGIIbxLkADHcnUtUSTZa/TafjKA75u7SpQNoVEV
        vD2lkrBjZfA7Brq2weBsB4/nM42LaFmFZwBcBWGQqs8htKy7mHZc4iGO5KNe0xe3OjZzaSS1EeG
        fduGOojs4CsYF
X-Received: by 2002:a5d:5282:: with SMTP id c2mr11495847wrv.64.1572620331284;
        Fri, 01 Nov 2019 07:58:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYRVYd4RHoXHZFROnIZg1uxaQ3GsmE55MirQ4XHKYprZnLGzQP+1TI9f9BuF7E+JA84iaxlw==
X-Received: by 2002:a5d:5282:: with SMTP id c2mr11495825wrv.64.1572620331055;
        Fri, 01 Nov 2019 07:58:51 -0700 (PDT)
Received: from xz-x1.metropole.lan ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id b3sm8131614wrv.40.2019.11.01.07.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 07:58:50 -0700 (PDT)
Date:   Fri, 1 Nov 2019 15:58:48 +0100
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 05/22] vfio/common: add iommu_ctx_notifier in container
Message-ID: <20191101145848.GD8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-6-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-6-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:26AM -0400, Liu Yi L wrote:

[...]

> +typedef struct VFIOIOMMUContext {
> +    VFIOContainer *container;
> +    IOMMUContext *iommu_ctx;
> +    IOMMUCTXNotifier n;
> +    QLIST_ENTRY(VFIOIOMMUContext) iommu_ctx_next;
> +} VFIOIOMMUContext;
> +

No strong opinion on this - but for me it would be more meaningful to
squash this patch into where this struct is firstly used.

-- 
Peter Xu
