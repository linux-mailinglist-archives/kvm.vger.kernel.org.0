Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11D118E62
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLJQ6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 11:58:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727534AbfLJQ6g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 11:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575997114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kloBvw8RGWK1lP3SGtf1eARoYVSiVMuq6V2S364vtNA=;
        b=MrvvEQqZ9IjHgdWhnGrLfZ9sNtPcN7QYa1fx9SLjWFrM5vYLWv2tHPpYLgVrzVzLR9Mt93
        oF0QnKIa1ktTt5G6g2N8U99IPbE+/LcM4C1oABEXzZOzmIG2EYg/Ty5figCyC44hy41q/G
        mZ4DYI5GFbu5TfY51ILoUVQvk2rjFJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-a3Q0C6xYPXGoFovyHN5gSQ-1; Tue, 10 Dec 2019 11:58:31 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38AA41005512;
        Tue, 10 Dec 2019 16:58:30 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3154360BE1;
        Tue, 10 Dec 2019 16:58:25 +0000 (UTC)
Date:   Tue, 10 Dec 2019 09:58:24 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept
 vfio-pci ops
Message-ID: <20191210095824.5c4cdad7@x1.home>
In-Reply-To: <20191210024422.GA27331@joy-OptiPlex-7040>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <20191205032536.29653-1-yan.y.zhao@intel.com>
        <20191205165519.106bd210@x1.home>
        <20191206075655.GG31791@joy-OptiPlex-7040>
        <20191206142226.2698a2be@x1.home>
        <20191209034225.GK31791@joy-OptiPlex-7040>
        <20191209170339.2cb3d06e@x1.home>
        <20191210024422.GA27331@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: a3Q0C6xYPXGoFovyHN5gSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Dec 2019 21:44:23 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> > > > > Currently, yes, i40e has build dependency on vfio-pci.
> > > > > It's like this, if i40e decides to support SRIOV and compiles in vf
> > > > > related code who depends on vfio-pci, it will also have build dependency
> > > > > on vfio-pci. isn't it natural?    
> > > > 
> > > > No, this is not natural.  There are certainly i40e VF use cases that
> > > > have no interest in vfio and having dependencies between the two
> > > > modules is unacceptable.  I think you probably want to modularize the
> > > > i40e vfio support code and then perhaps register a table in vfio-pci
> > > > that the vfio-pci code can perform a module request when using a
> > > > compatible device.  Just and idea, there might be better options.  I
> > > > will not accept a solution that requires unloading the i40e driver in
> > > > order to unload the vfio-pci driver.  It's inconvenient with just one
> > > > NIC driver, imagine how poorly that scales.
> > > >     
> > > what about this way:
> > > mediate driver registers a module notifier and every time when
> > > vfio_pci is loaded, register to vfio_pci its mediate ops?
> > > (Just like in below sample code)
> > > This way vfio-pci is free to unload and this registering only gives
> > > vfio-pci a name of what module to request.
> > > After that,
> > > in vfio_pci_open(), vfio-pci requests the mediate driver. (or puts
> > > the mediate driver when mediate driver does not support mediating the
> > > device)
> > > in vfio_pci_release(), vfio-pci puts the mediate driver.
> > > 
> > > static void register_mediate_ops(void)
> > > {
> > >         int (*func)(struct vfio_pci_mediate_ops *ops) = NULL;
> > > 
> > >         func = symbol_get(vfio_pci_register_mediate_ops);
> > > 
> > >         if (func) {
> > >                 func(&igd_dt_ops);
> > >                 symbol_put(vfio_pci_register_mediate_ops);
> > >         }
> > > }
> > > 
> > > static int igd_module_notify(struct notifier_block *self,
> > >                               unsigned long val, void *data)
> > > {
> > >         struct module *mod = data;
> > >         int ret = 0;
> > > 
> > >         switch (val) {
> > >         case MODULE_STATE_LIVE:
> > >                 if (!strcmp(mod->name, "vfio_pci"))
> > >                         register_mediate_ops();
> > >                 break;
> > >         case MODULE_STATE_GOING:
> > >                 break;
> > >         default:
> > >                 break;
> > >         }
> > >         return ret;
> > > }
> > > 
> > > static struct notifier_block igd_module_nb = {
> > >         .notifier_call = igd_module_notify,
> > >         .priority = 0,
> > > };
> > > 
> > > 
> > > 
> > > static int __init igd_dt_init(void)
> > > {
> > > 	...
> > > 	register_mediate_ops();
> > > 	register_module_notifier(&igd_module_nb);
> > > 	...
> > > 	return 0;
> > > }  
> > 
> > 
> > No, this is bad.  Please look at MODULE_ALIAS() and request_module() as
> > used in the vfio-platform for loading reset driver modules.  I think
> > the correct approach is that vfio-pci should perform a request_module()
> > based on the device being probed.  Having the mediation provider
> > listening for vfio-pci and registering itself regardless of whether we
> > intend to use it assumes that we will want to use it and assumes that
> > the mediation provider module is already loaded.  We should be able to
> > support demand loading of modules that may serve no other purpose than
> > providing this mediation.  Thanks,  
> hi Alex
> Thanks for this message.
> So is it good to create a separate module as mediation provider driver,
> and alias its module name to "vfio-pci-mediate-vid-did".
> Then when vfio-pci probes the device, it requests module of that name ?

I think this would give us an option to have the mediator as a separate
module, but not require it.  Maybe rather than a request_module(),
where if we follow the platform reset example we'd then expect the init
code for the module to register into a list, we could do a
symbol_request().  AIUI, this would give us a reference to the symbol
if the module providing it is already loaded, and request a module
(perhaps via an alias) if it's not already load.  Thanks,

Alex

