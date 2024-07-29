Return-Path: <kvm+bounces-22488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CAC93F36F
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC9E42826DE
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 10:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF78614534C;
	Mon, 29 Jul 2024 10:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NyHPxEOi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2F575816
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722250725; cv=none; b=ZJnngQ4E/BwLoFvlLa9ToialpOTlIDSANpGvCvnyR1I1MNhl1O5jNyQKvO5z4HoWYGEAsY90abS4l4WCnsjaE+4GRTUzlbOcYNWkfd1n7smlUEGWjPC6hY6tXcB2K86QWGgNwBiQd8Kyjl0lU7urzRYPSYSvkMovIbdlLfPO5b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722250725; c=relaxed/simple;
	bh=a7s1fdvBUNz3sqTFdN8Lffd18N1VFnl9MOnNQhO/GBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byhCrGJbp+Zjvl+Ad/i7QK/MmSAPqp/1kctzPZNPQ/K66E9/d4vmi/q9z8HEwNc6vqzZpEL4FNzMsIH3ljnNyAeEbdHC1n4ZOPx/WUfWwu8wrsWAN8hK8TwJSni8BlqYdFLztFFQhUZkUzl52KlR7eHtsn3/MSlDnVMxtyORegk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NyHPxEOi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722250721;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=DJVO6EmDnCOMxh1KXNwzZT/gFc6L6PBNcI8l/LMriwE=;
	b=NyHPxEOiESVbfkHy2FZKnwv7tSXdDfUeN6eZ1nWVav9gSXFecBSw+0R9BpqmAixJKVP9tI
	imIKnA4m+zoRzJ18K4e0A9f3euaK9yAlLzr51HYxbN5HFVAkxb5B7ToI2pHhxjBSj8P40D
	MG3VXmPx8F630eTe7FZQYsOCqtuGrLE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-K9OQYNd9N4WF8lqAdILW2g-1; Mon,
 29 Jul 2024 06:58:38 -0400
X-MC-Unique: K9OQYNd9N4WF8lqAdILW2g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44C981955D53;
	Mon, 29 Jul 2024 10:58:36 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A70FC19560AE;
	Mon, 29 Jul 2024 10:58:29 +0000 (UTC)
Date: Mon, 29 Jul 2024 11:58:26 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-arm@nongnu.org, Radoslaw Biernacki <rad@semihalf.com>,
	Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 07/13] tests/avocado/kvm_xen_guest.py: cope with asset RW
 requirements
Message-ID: <Zqd10nIix4gXKtDw@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-8-crosa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726134438.14720-8-crosa@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Jul 26, 2024 at 09:44:32AM -0400, Cleber Rosa wrote:
> Some of these tests actually require the root filesystem image,
> obtained through Avocado's asset feature and kept in a common cache
> location, to be writable.
> 
> This makes a distinction between the tests that actually have this
> requirement and those who don't.  The goal is to be as safe as
> possible, avoiding causing cache misses (because the assets get
> modified and thus need to be dowloaded again) while avoid copying the
> root filesystem backing file whenever possible.
> 
> This also allow these tests to be run in parallel with newer Avocado
> versions.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>  tests/avocado/kvm_xen_guest.py | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
> index 318fadebc3..d73fa888ef 100644
> --- a/tests/avocado/kvm_xen_guest.py
> +++ b/tests/avocado/kvm_xen_guest.py
> @@ -10,6 +10,7 @@
>  # SPDX-License-Identifier: GPL-2.0-or-later
>  
>  import os
> +import shutil
>  
>  from qemu.machine import machine
>  
> @@ -43,7 +44,7 @@ def get_asset(self, name, sha1):
>          return self.fetch_asset(name=f"qemu-kvm-xen-guest-{name}",
>                                  locations=(url), asset_hash=sha1)
>  
> -    def common_vm_setup(self):
> +    def common_vm_setup(self, readwrite=False):
>          # We also catch lack of KVM_XEN support if we fail to launch
>          self.require_accelerator("kvm")
>  
> @@ -56,11 +57,19 @@ def common_vm_setup(self):
>                                            "367962983d0d32109998a70b45dcee4672d0b045")
>          self.rootfs = self.get_asset("rootfs.ext4",
>                                       "f1478401ea4b3fa2ea196396be44315bab2bb5e4")
> +        if readwrite:
> +            dest = os.path.join(self.workdir, os.path.basename(self.rootfs))
> +            shutil.copy(self.rootfs, dest)
> +            self.rootfs = dest

This is a very expensive way of creating a writable disk. Better to
avoid adding this 'readwrite' parameter at all, and instead create
a throwaway qcow2 overlay for the image for all tests. That ensures
writability for everything in a cheap manner.

>  
> -    def run_and_check(self):
> +    def run_and_check(self, readwrite=False):
> +        if readwrite:
> +            drive = f"file={self.rootfs},if=none,format=raw,id=drv0"
> +        else:
> +            drive = f"file={self.rootfs},if=none,readonly=on,format=raw,id=drv0"
>          self.vm.add_args('-kernel', self.kernel_path,
>                           '-append', self.kernel_params,
> -                         '-drive',  f"file={self.rootfs},if=none,snapshot=on,format=raw,id=drv0",
> +                         '-drive',  drive,
>                           '-device', 'xen-disk,drive=drv0,vdev=xvda',
>                           '-device', 'virtio-net-pci,netdev=unet',
>                           '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
> @@ -90,11 +99,11 @@ def test_kvm_xen_guest(self):
>          :avocado: tags=kvm_xen_guest
>          """
>  
> -        self.common_vm_setup()
> +        self.common_vm_setup(True)
>  
>          self.kernel_params = (self.KERNEL_DEFAULT +
>                                ' xen_emul_unplug=ide-disks')
> -        self.run_and_check()
> +        self.run_and_check(True)
>          self.ssh_command('grep xen-pirq.*msi /proc/interrupts')
>  
>      def test_kvm_xen_guest_nomsi(self):
> @@ -102,11 +111,11 @@ def test_kvm_xen_guest_nomsi(self):
>          :avocado: tags=kvm_xen_guest_nomsi
>          """
>  
> -        self.common_vm_setup()
> +        self.common_vm_setup(True)
>  
>          self.kernel_params = (self.KERNEL_DEFAULT +
>                                ' xen_emul_unplug=ide-disks pci=nomsi')
> -        self.run_and_check()
> +        self.run_and_check(True)
>          self.ssh_command('grep xen-pirq.* /proc/interrupts')
>  
>      def test_kvm_xen_guest_noapic_nomsi(self):
> @@ -114,11 +123,11 @@ def test_kvm_xen_guest_noapic_nomsi(self):
>          :avocado: tags=kvm_xen_guest_noapic_nomsi
>          """
>  
> -        self.common_vm_setup()
> +        self.common_vm_setup(True)
>  
>          self.kernel_params = (self.KERNEL_DEFAULT +
>                                ' xen_emul_unplug=ide-disks noapic pci=nomsi')
> -        self.run_and_check()
> +        self.run_and_check(True)
>          self.ssh_command('grep xen-pirq /proc/interrupts')
>  
>      def test_kvm_xen_guest_vapic(self):
> -- 
> 2.45.2
> 
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


