Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0097BEC781
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfKAR0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 13:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfKAR0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 13:26:51 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04EA783F4C
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 17:26:51 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id g17so1163666wru.4
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 10:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lYshMNMD074lqt0Gg9jN8T6k7Bw9MrDOl7A9NGI200I=;
        b=mQ8EmjC+74seWvHgKd+AWrtsHvkfgxPJq60pKFolRT5WWIJaJHQqRmPma9zgJH8cvv
         rKkar755s6e9m47ptqOKXKJY3J2/aHG3neb4WJrFjNss7+yA5tiXK7BF6Hu0NQlSAiv+
         wheGRmbfhOdIl5tWY6NM7SKEeZml3OQHo3YbYaWkzzXBOaC/yZrNcVWbSKmSkSSS26PO
         ZAxfrd+nRG+mHlRSRPnnIVzZOJFuprtQy5uCLQEdwnI6UPfuIIeZq12NfwXvA02XJEV5
         jsv3rt8M8rri0/5ujMuU0aVvt335gJL8sm7JxK23XOoDsgC7AfSByRc74LDnLjr0sean
         6Puw==
X-Gm-Message-State: APjAAAUbF0gCNjucUiztoF6YPgrR6BjY7tmjJJr4jvhpKa941aAYnN55
        HcBCDFljs2PnFEU/iPfkezqo8rngj+apnQNi3A2hckFbk/MaJOCSMOlZ6tYBD068PqA0ej4hnAK
        hsOXFIpNsU9xE
X-Received: by 2002:a5d:490c:: with SMTP id x12mr8551896wrq.301.1572629209768;
        Fri, 01 Nov 2019 10:26:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyeBQKScOYmEnkCvl0Q4sIZz/ZTgjjIPvlYo17THGClSuijIBO86k+SNVgCfmy98TH4LxZmOA==
X-Received: by 2002:a5d:490c:: with SMTP id x12mr8551876wrq.301.1572629209566;
        Fri, 01 Nov 2019 10:26:49 -0700 (PDT)
Received: from xz-x1.metropole.lan (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id y2sm8113738wmy.2.2019.11.01.10.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 10:26:48 -0700 (PDT)
Date:   Fri, 1 Nov 2019 18:26:21 +0100
From:   Peter Xu <peterx@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        eric.auger@redhat.com, tianyu.lan@intel.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Message-ID: <20191101172349.GE8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
 <20191029121544.GS3552@umbus.metropole.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191029121544.GS3552@umbus.metropole.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 01:15:44PM +0100, David Gibson wrote:
> > +union IOMMUCTXPASIDReqDesc {
> > +    struct {
> > +        uint32_t min_pasid;
> > +        uint32_t max_pasid;
> > +        int32_t alloc_result; /* pasid allocated for the alloc request */
> > +    };
> > +    struct {
> > +        uint32_t pasid; /* pasid to be free */
> > +        int free_result;
> > +    };
> > +};
> 
> Apart from theproblem with writable fields, using a big union for
> event data is pretty ugly.  If you need this different information for
> the different events, it might make more sense to have a separate
> notifier chain with a separate call interface for each event type,
> rather than trying to multiplex them together.

I have no issue on the union definiion, however I do agree that it's a
bit awkward to register one notifier for each event.

Instead of introducing even more notifier chains, I'm thinking whether
we can simply provide a single notifier hook for all the four events.
After all I don't see in what case we'll only register some of the
events, like we can't register alloc_pasid() without registering to
free_pasid() because otherwise it does not make sense..  And also you
have the wrapper struct ("IOMMUCTXEventData") which contains the event
type, so the notify() hook will know which message is this.

A side note is that I think you don't need the
IOMMUCTXEventData.length.  If you see the code, vtd_bind_guest_pasid()
does not even initialize length right now, and I think it could still
work only because none of the vfio notify() hook
(e.g. vfio_iommu_pasid_bind_notify) checks that length...

-- 
Peter Xu
