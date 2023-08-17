Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE4677FF4B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355025AbjHQUuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 16:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355023AbjHQUui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 16:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677B53588
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 13:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692305389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnb5/hFDL0E2J4CmpV2NeqUWW2XWukYwmupqHzwCPi8=;
        b=YyobC88brZUf2ud/8k6ur+7oSy+Yew55L/KW47F/kwWUVpXoTdZx//q9qa61pfLupAxFmh
        hHdGSTQEvVow/lfzIwTQXEmMuf73C7yf4+rtYIUCjy+kELNJWTpm3tsBlZx/UJ7sjAaTzd
        Su4vKD1MJ59yvTWU07+2qiTkJe4n+D0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-eS5WeKA4OhS26TqX2q4SjQ-1; Thu, 17 Aug 2023 16:49:47 -0400
X-MC-Unique: eS5WeKA4OhS26TqX2q4SjQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-993831c639aso10892766b.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 13:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692305386; x=1692910186;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnb5/hFDL0E2J4CmpV2NeqUWW2XWukYwmupqHzwCPi8=;
        b=JnaQiGZA1PfqIfQ5yMBEWtbOCHQqcNC5VXgzVVEve2XADrCML0fDZCISlDWBwfXL24
         YFwbepXAgqJOb/b/YOeTXLoVvu5bawc0bCaZx4AWOaRFg56cGI1nGl/n5wVGQlMFqDfR
         mQztuIyUjXFyhF7QNwPLbhnhhiQuI0rkmEAFaXGKwyUVCVkiHZv9zbdjIKJQJiThJfut
         ETUtpDWMEVT+1tmy2OMHkyOynZKUG8XgSMDQAla/BCBQu6HUlxW6PX5k/eYCgUdUuWud
         /FurMU77SiDn/NIsLs0B8krQdDiMD1Emx++ViJ1+Qx2rjlBzSgZYWKGKpQu7dcOxN/yi
         5xUg==
X-Gm-Message-State: AOJu0YxPtmdQEt861mJsQKP1E9iZF0GNt7O8wYoh+StxKexreYE0MAJt
        3t6C7F3GmQ8ienbj8/07aJ/hmdqffRRnBtMjjLbbbpzA2a262YgLExb0TG9Gxw4rNQ1ToW1YcU/
        XDm+uw18ypIkQ
X-Received: by 2002:a17:906:23f2:b0:99c:7915:b844 with SMTP id j18-20020a17090623f200b0099c7915b844mr365882ejg.57.1692305386459;
        Thu, 17 Aug 2023 13:49:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5XOcHZWhAQpLhs9JnMbeySnJ3npOlp3SCpX9B/+DD3Cyag74tsK7CAt2uiDjuhC2jD4rt8g==
X-Received: by 2002:a17:906:23f2:b0:99c:7915:b844 with SMTP id j18-20020a17090623f200b0099c7915b844mr365874ejg.57.1692305386174;
        Thu, 17 Aug 2023 13:49:46 -0700 (PDT)
Received: from starship ([77.137.131.138])
        by smtp.gmail.com with ESMTPSA id t3-20020a170906a10300b00993860a6d37sm218619ejy.40.2023.08.17.13.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 13:49:45 -0700 (PDT)
Message-ID: <4a927976cba33e07a765d38ba6291d2d3f55254b.camel@redhat.com>
Subject: Re: Commit 'sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then
 sendpage' broke O_DIRECT over NFS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Thu, 17 Aug 2023 23:49:43 +0300
In-Reply-To: <617E47EE-77B4-4904-A32B-56F3E50895CA@oracle.com>
References: <2d47431decaaf4bba0023c91ef0d7fd51b84333b.camel@redhat.com>
         <4DB1C27A-1B89-468A-9103-80DEDBF1A091@oracle.com>
         <617E47EE-77B4-4904-A32B-56F3E50895CA@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У чт, 2023-08-17 у 15:58 +0000, Chuck Lever III пише:
> > On Aug 17, 2023, at 11:57 AM, Chuck Lever <chuck.lever@oracle.com> wrote:
> > 
> > 
> > 
> > > On Aug 17, 2023, at 11:52 AM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > 
> > > Hi!
> > > 
> > > I just updated my developement systems to 6.5-rc6 (from 6.4) and now I can't start a VM 
> > > with a disk which is mounted over the NFS.
> > > 
> > > The VM has two qcow2 files, one depends on another and qemu opens both.
> > > 
> > > This is the command line of qemu:
> > > 
> > > -drive if=none,id=os_image,file=./disk_s1.qcow2,aio=native,discard=unmap,cache=none
> > > 
> > > The disk_s1.qcow2 depends on disk_s0.qcow2
> > > 
> > > However this is what I get:
> > > 
> > > qemu-system-x86_64: -drive if=none,id=os_image,file=./disk_s1.qcow2,aio=native,discard=unmap,cache=none: Could not open backing file: Could not open './QFI?': No such file or directory
> > > 
> > > 'QFI?' is qcow2 file signature, which signals that there might be some nasty corruption happening.
> > > 
> > > The program was supposed to read a field inside the disk_s1.qcow2 file which should read 'disk_s0.qcow2' 
> > > but instead it seems to read the first 4 bytes of the file.
> > > 
> > > 
> > > Bisect leads to the above commit. Reverting it was not possible due to many changes.
> > > 
> > > Both the client and the server were tested with the 6.5-rc6 kernel, but once rebooting the server into
> > > the 6.4, the bug disappeared, thus I did a bisect on the server.
> > > 
> > > When I tested a version before the offending commit on the server, the 6.5-rc6 client was able to work with it,
> > > which increases the chances that the bug is in nfsd.
> > > 
> > > Switching qemu to use write back paging also helps (aio=threads,discard=unmap,cache=writeback)
> > > The client and the server (both 6.5-rc6) work with this configuration.
> > > 
> > > Running the VM on the same machine (also 6.5-rc6) where the VM disk is located (thus avoiding NFS) works as well.
> > > 
> > > I tested several VMs that I have, all are affected in the same way.
> > > 
> > > I run somewhat outdated qemu, but running the latest qemu doesn't make a difference.
> > > 
> > > I use nfs4.
> > > 
> > > I can test patches and provide more info if needed.
> > 
> > Linus just merged a possible fix for this issue. See:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ master
> 
> In particular:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c96e2a695e00bca5487824d84b85aab6aa2c1891

I just tested it. It does help (qemu doesn't crash anymore) but it doesn't eliminate the issue (VM still doesn't boot)

The VM now starts but it drops into the UEFI shell.

Once again, disabling O_DIRECT helps (that is -aio=threads,cache=writeback)

For the reference, few kernels ago, I had an unrelated bug (not even NFS related, it was happening locally as well),
which caused the exact same drop to the UEFI shell when using O_DIRECT:

https://www.mail-archive.com/qemu-devel@nongnu.org/msg912549.html

It was decided that this issue is a qemu issue because it relied on undefined kernel behavior which has changed,
so the qemu got patched to fix the issue on its side.

Since sometimes I use an older qemu version, I had this kernel commit reverted for now, but to be sure I now had built a kernel
without the revert on both server and the client, and tested with the latest qemu which has the fix for the bug.

I don't remember details of this unrelated bug, but if I remember correctly, qemu had trouble reading first 512 bytes of the virtual disk, when
the VM tried to do so to read the boot sector.


Best regards,
	Maxim Levitsky

> 
> 
> --
> Chuck Lever
> 
> 


