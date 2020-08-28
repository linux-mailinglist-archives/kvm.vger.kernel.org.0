Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7378B255B88
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgH1NsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 09:48:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726321AbgH1NsF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 09:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598622484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PyImQr8Vv71Nkg4eGLf/31gz0soaKXkRyk+wNyHdUvU=;
        b=a4BmW7igN0nosE1ZDkltWUilMgkuRliEVXXEi9fQcd78Vd/kOiK4g0bGGWR85ac1kYnMUq
        92IcLl8l1kuSOdoWU+8W7JrU03gQ2EyWwG1WbR18xSBQAjXO0jHeq2ZJbdXWazeLR3LUWX
        z6gkZjysSmlIiHm3AC/w7vK9Tf9TBA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-Ets9HjX7NxWOzyPhwKwiwA-1; Fri, 28 Aug 2020 09:48:02 -0400
X-MC-Unique: Ets9HjX7NxWOzyPhwKwiwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37BBE8730A8;
        Fri, 28 Aug 2020 13:47:59 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5F055C1D0;
        Fri, 28 Aug 2020 13:47:44 +0000 (UTC)
Date:   Fri, 28 Aug 2020 15:47:41 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Daniel =?UTF-8?B?UC5C?= =?UTF-8?B?ZXJyYW5nw6k=?=" 
        <berrange@redhat.com>, kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn, smooney@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, eskultet@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, dinechin@redhat.com,
        devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200828154741.30cfc1a3.cohuck@redhat.com>
In-Reply-To: <20200826064117.GA22243@joy-OptiPlex-7040>
References: <20200814051601.GD15344@joy-OptiPlex-7040>
        <a51209fe-a8c6-941f-ff54-7be06d73bc44@redhat.com>
        <20200818085527.GB20215@redhat.com>
        <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
        <20200818091628.GC20215@redhat.com>
        <20200818113652.5d81a392.cohuck@redhat.com>
        <20200820003922.GE21172@joy-OptiPlex-7040>
        <20200819212234.223667b3@x1.home>
        <20200820031621.GA24997@joy-OptiPlex-7040>
        <20200825163925.1c19b0f0.cohuck@redhat.com>
        <20200826064117.GA22243@joy-OptiPlex-7040>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Aug 2020 14:41:17 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> previously, we want to regard the two mdevs created with dsa-1dwq x 30 and
> dsa-2dwq x 15 as compatible, because the two mdevs consist equal resources.
> 
> But, as it's a burden to upper layer, we agree that if this condition
> happens, we still treat the two as incompatible.
> 
> To fix it, either the driver should expose dsa-1dwq only, or the target
> dsa-2dwq needs to be destroyed and reallocated via dsa-1dwq x 30.

AFAIU, these are mdev types, aren't they? So, basically, any management
software needs to take care to use the matching mdev type on the target
system for device creation?

