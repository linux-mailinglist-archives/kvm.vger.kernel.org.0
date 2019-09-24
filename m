Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDCBC8E7
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436663AbfIXN2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfIXN2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:28:16 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19927C057F88
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:28:16 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id h4so1915613qkd.18
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0siV7+IiGRtmpsjCKKKrKw8qwzwFcfU/O5o31oDtQNM=;
        b=HWqgOL4CKSTM3ivbwb2TnQr4L/9V8gOnLLHZHO/WrtKSTHbrHd06hrQAtJZUOQwVma
         LEsSIlWK2I8m19/4T173o28jxHTob2FgRx5JhpBcUS8ZQUBAh+HS/t+YdavWLhwPQMZB
         Jlka6aPVHZOCPP3sCgMEYdcRBlme3y2rHtwbR0gWdViHxd5plB/69K5dvboYoB7OPMXU
         voVCZ09rQkLcMgfsGOfElqNom+FgFi0oIq17LbxdQ0xATSPyIJZgvUwUt0yvA4MF4Lb6
         K7r2RtNyAYPOzPDFAtk1yrOG66n35geyJqEVXYHNz5ES13HJrSDmRfV/WaVhmdEShq6m
         2T2Q==
X-Gm-Message-State: APjAAAVau4edXhvFElVOq1HE52JWru6FNbR7hBE56jZ28LniMn2mt7fG
        XruiRb+C4GW/+Ib8GLRbQu4dE/VWy9CYaiX9LCZ6nfVsGhQuW7AUdFzaSKsezoE6FJHGLaOYjnf
        NVGEaYDL77efQ
X-Received: by 2002:a37:af81:: with SMTP id y123mr2346001qke.145.1569331695453;
        Tue, 24 Sep 2019 06:28:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8IETc94LHUvszYZmbbVF9ufeHqsjMgwcWGWqmPhUsAF9oomZniLkKp52I24u6LE51VHqlag==
X-Received: by 2002:a37:af81:: with SMTP id y123mr2345985qke.145.1569331695302;
        Tue, 24 Sep 2019 06:28:15 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id z72sm956187qka.115.2019.09.24.06.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 06:28:14 -0700 (PDT)
Date:   Tue, 24 Sep 2019 09:28:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
Message-ID: <20190924092435-mutt-send-email-mst@kernel.org>
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924124433.96810-9-slp@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 02:44:33PM +0200, Sergio Lopez wrote:
> +static void microvm_fix_kernel_cmdline(MachineState *machine)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(machine);
> +    BusState *bus;
> +    BusChild *kid;
> +    char *cmdline;
> +
> +    /*
> +     * Find MMIO transports with attached devices, and add them to the kernel
> +     * command line.
> +     *
> +     * Yes, this is a hack, but one that heavily improves the UX without
> +     * introducing any significant issues.
> +     */
> +    cmdline = g_strdup(machine->kernel_cmdline);
> +    bus = sysbus_get_default();
> +    QTAILQ_FOREACH(kid, &bus->children, sibling) {
> +        DeviceState *dev = kid->child;
> +        ObjectClass *class = object_get_class(OBJECT(dev));
> +
> +        if (class == object_class_by_name(TYPE_VIRTIO_MMIO)) {
> +            VirtIOMMIOProxy *mmio = VIRTIO_MMIO(OBJECT(dev));
> +            VirtioBusState *mmio_virtio_bus = &mmio->bus;
> +            BusState *mmio_bus = &mmio_virtio_bus->parent_obj;
> +
> +            if (!QTAILQ_EMPTY(&mmio_bus->children)) {
> +                gchar *mmio_cmdline = microvm_get_mmio_cmdline(mmio_bus->name);
> +                if (mmio_cmdline) {
> +                    char *newcmd = g_strjoin(NULL, cmdline, mmio_cmdline, NULL);
> +                    g_free(mmio_cmdline);
> +                    g_free(cmdline);
> +                    cmdline = newcmd;
> +                }
> +            }
> +        }
> +    }
> +
> +    fw_cfg_modify_i32(x86ms->fw_cfg, FW_CFG_CMDLINE_SIZE, strlen(cmdline) + 1);
> +    fw_cfg_modify_string(x86ms->fw_cfg, FW_CFG_CMDLINE_DATA, cmdline);
> +}

Can we rearrange this somewhat? Maybe the mmio constructor
would format the device description and add to some list,
and then microvm would just get stuff from that list
and add it to kernel command line?
This way it can also be controlled by a virtio-mmio property, so
e.g. you can disable it per device if you like.
In particular, this seems like a handy trick for any machine type
using mmio.

-- 
MST
