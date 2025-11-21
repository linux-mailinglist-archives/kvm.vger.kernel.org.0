Return-Path: <kvm+bounces-64015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B16C76B80
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E88F73573D3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9593F1B423B;
	Fri, 21 Nov 2025 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="SjPx7AiS"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA813959D
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684134; cv=none; b=Y/6JOyrwXU37Eoi2o8ANLbiCHUT3kA5gXDVfw786XKd7tWTyvzdP5Ic2AgZQSA0cyvy6D1WWuWLStWqmGjl8rTC3MAQJDGDEZ2phSCct48c9kBCCQ2KfYh/XrjOq+LKoOSKAC/tsyDeO5fr3UXT2mpJttJ+nY+uh+RAX4WNPIp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684134; c=relaxed/simple;
	bh=Oc2nhdbEfblLl6BxWgOo/zHF8YFTUEzO1k4bwv0yF3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/ftDNP3wsoMd5eP8sBVI4w9gFB5+KsEl44ne5KULrS0CDNsERCphYg92HS+nIr40njWmppCoW7Akes0R1xAL1OXKs0ax7pK7HQVjooHWEuzUJEcrr0MICR89GFLAEGALyE8oN5BRdyOBGzJKJSdO4+hxxm9j9U4KgQdjGaE9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=SjPx7AiS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=amKb911rYLxhP+db/dvSJFXgaACJD9GturT1fn3TAQA=; b=SjPx7AiS/6BZyg4j
	MH4JVdiVd9Vms2EKybj2d/SOA5XqLw3oAkKAfIyNDhkriEGkcNDq95jAkCBdpX+KQlRsBifYkpHVv
	1jHJsFp+UGFxM28lj4+K28Zw+q2fVgxgwf/U7VhA1j7fEYYxQ5FScSJLYBHuh25l/Pr7P3frXnwZ9
	Pj7WsIGxXCD5F+WBjimIjZ4q1CKhE1QSfQWTWvs1BAc9ghtfjdke9qfbdimoSfnS1LZj22sJ/zco7
	qCMMyGQn935klyclHkB+JbfZbyQPW/mBA1uuxu6UJNqxH+8tqzZM6AQCiO8j8r0pELAn/Rn1Gzo5D
	SwSU8jh7iDKrCjw5hw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMEnz-00000005cvd-0YBm;
	Fri, 21 Nov 2025 00:15:15 +0000
Date: Fri, 21 Nov 2025 00:15:15 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, arei.gonglei@huawei.com, pizhenwei@bytedance.com,
	alistair.francis@wdc.com, stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com, hreitz@redhat.com, sw@weilnetz.de,
	qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
	imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
	shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
	sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
	edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
	jag.raman@oracle.com, sgarzare@redhat.com, pbonzini@redhat.com,
	fam@euphon.net, philmd@linaro.org, alex@shazbot.org, clg@redhat.com,
	peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
	jasowang@redhat.com, samuel.thibault@ens-lyon.org,
	michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
	mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
	liwei1518@gmail.com, dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
	qemu-block@nongnu.org, qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: Re: [PATCH 12/14] error: Use error_setg_errno() for simplicity and
 consistency
Message-ID: <aR-vExiomEe9jUNN@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-13-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-13-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 00:14:43 up 24 days, 23:50,  2 users,  load average: 0.06, 0.02,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> Use error_setg_errno() instead of passing the value of strerror() or
> g_strerror() to error_setg().
> 
> The separator between the error message proper and the value of
> strerror() changes from " : ", "", " - ", "- " to ": " in places.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

> @@ -792,9 +792,9 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
>                             VFU_REGION_FLAG_RW | VFU_REGION_FLAG_ALWAYS_CB,
>                             NULL, 0, -1, 0);
>      if (ret < 0) {
> -        error_setg(errp,
> -                   "vfu: Failed to setup config space handlers for %s- %s",
> -                   o->device, strerror(errno));
> +        error_setg_errno(errp,
> +                         "vfu: Failed to setup config space handlers for %s",
> +                         o->device);

missing errno.

>          goto fail;
>      }
>  
> @@ -822,8 +822,8 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
>  
>      ret = vfu_realize_ctx(o->vfu_ctx);
>      if (ret < 0) {
> -        error_setg(errp, "vfu: Failed to realize device %s- %s",
> -                   o->device, strerror(errno));
> +        error_setg_errno(errp, "vfu: Failed to realize device %s",
> +                         o->device);

missing errno.

Dave

>          goto fail;
>      }
>  
> diff --git a/hw/sensor/emc141x.c b/hw/sensor/emc141x.c
> index 7b2ce383a1..a51fc44395 100644
> --- a/hw/sensor/emc141x.c
> +++ b/hw/sensor/emc141x.c
> @@ -59,7 +59,7 @@ static void emc141x_get_temperature(Object *obj, Visitor *v, const char *name,
>      unsigned tempid;
>  
>      if (sscanf(name, "temperature%u", &tempid) != 1) {
> -        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
> +        error_setg_errno(errp, errno, "error reading %s", name);
>          return;
>      }
>  
> @@ -86,7 +86,7 @@ static void emc141x_set_temperature(Object *obj, Visitor *v, const char *name,
>      }
>  
>      if (sscanf(name, "temperature%u", &tempid) != 1) {
> -        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
> +        error_setg_errno(errp, errno, "error reading %s", name);
>          return;
>      }
>  
> diff --git a/hw/sensor/tmp421.c b/hw/sensor/tmp421.c
> index 3421c44086..127edd0ba5 100644
> --- a/hw/sensor/tmp421.c
> +++ b/hw/sensor/tmp421.c
> @@ -117,7 +117,7 @@ static void tmp421_get_temperature(Object *obj, Visitor *v, const char *name,
>      int tempid;
>  
>      if (sscanf(name, "temperature%d", &tempid) != 1) {
> -        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
> +        error_setg_errno(errp, errno, "error reading %s", name);
>          return;
>      }
>  
> @@ -154,7 +154,7 @@ static void tmp421_set_temperature(Object *obj, Visitor *v, const char *name,
>      }
>  
>      if (sscanf(name, "temperature%d", &tempid) != 1) {
> -        error_setg(errp, "error reading %s: %s", name, g_strerror(errno));
> +        error_setg_errno(errp, errno, "error reading %s", name);
>          return;
>      }
>  
> diff --git a/hw/smbios/smbios.c b/hw/smbios/smbios.c
> index 7558b2ad83..b228f9eb85 100644
> --- a/hw/smbios/smbios.c
> +++ b/hw/smbios/smbios.c
> @@ -1281,8 +1281,8 @@ static int save_opt_one(void *opaque,
>                  break;
>              }
>              if (ret < 0) {
> -                error_setg(errp, "Unable to read from %s: %s",
> -                           value, strerror(errno));
> +                error_setg_errno(errp, errno, "Unable to read from %s",
> +                                 value);
>                  qemu_close(fd);
>                  return -1;
>              }
> diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
> index 4a7b970976..f97d576171 100644
> --- a/hw/virtio/vdpa-dev.c
> +++ b/hw/virtio/vdpa-dev.c
> @@ -41,8 +41,8 @@ vhost_vdpa_device_get_u32(int fd, unsigned long int cmd, Error **errp)
>      uint32_t val = (uint32_t)-1;
>  
>      if (ioctl(fd, cmd, &val) < 0) {
> -        error_setg(errp, "vhost-vdpa-device: cmd 0x%lx failed: %s",
> -                   cmd, strerror(errno));
> +        error_setg_errno(errp, errno, "vhost-vdpa-device: cmd 0x%lx failed",
> +                         cmd);
>      }
>  
>      return val;
> diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
> index 3f98dcb6fd..5454372ac6 100644
> --- a/migration/postcopy-ram.c
> +++ b/migration/postcopy-ram.c
> @@ -582,7 +582,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
>  
>      ufd = uffd_open(O_CLOEXEC);
>      if (ufd == -1) {
> -        error_setg(errp, "Userfaultfd not available: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "Userfaultfd not available");
>          goto out;
>      }
>  
> @@ -620,7 +620,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
>       * it was enabled.
>       */
>      if (munlockall()) {
> -        error_setg(errp, "munlockall() failed: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "munlockall() failed");
>          goto out;
>      }
>  
> @@ -632,7 +632,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
>      testarea = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_PRIVATE |
>                                      MAP_ANONYMOUS, -1, 0);
>      if (testarea == MAP_FAILED) {
> -        error_setg(errp, "Failed to map test area: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "Failed to map test area");
>          goto out;
>      }
>      g_assert(QEMU_PTR_IS_ALIGNED(testarea, pagesize));
> @@ -642,14 +642,14 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis, Error **errp)
>      reg_struct.mode = UFFDIO_REGISTER_MODE_MISSING;
>  
>      if (ioctl(ufd, UFFDIO_REGISTER, &reg_struct)) {
> -        error_setg(errp, "UFFDIO_REGISTER failed: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "UFFDIO_REGISTER failed");
>          goto out;
>      }
>  
>      range_struct.start = (uintptr_t)testarea;
>      range_struct.len = pagesize;
>      if (ioctl(ufd, UFFDIO_UNREGISTER, &range_struct)) {
> -        error_setg(errp, "UFFDIO_UNREGISTER failed: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "UFFDIO_UNREGISTER failed");
>          goto out;
>      }
>  
> diff --git a/migration/rdma.c b/migration/rdma.c
> index ef4885ef5f..9e301cf917 100644
> --- a/migration/rdma.c
> +++ b/migration/rdma.c
> @@ -2349,7 +2349,7 @@ static int qemu_get_cm_event_timeout(RDMAContext *rdma,
>          error_setg(errp, "RDMA ERROR: poll cm event timeout");
>          return -1;
>      } else if (ret < 0) {
> -        error_setg_errno(errp, "RDMA ERROR: failed to poll cm event");
> +        error_setg_errno(errp, errno, "RDMA ERROR: failed to poll cm event");
>          return -1;
>      } else if (poll_fd.revents & POLLIN) {
>          if (rdma_get_cm_event(rdma->channel, cm_event) < 0) {
> diff --git a/net/slirp.c b/net/slirp.c
> index 5996fec512..04925f3318 100644
> --- a/net/slirp.c
> +++ b/net/slirp.c
> @@ -1020,8 +1020,9 @@ static int slirp_smb(SlirpState* s, const char *exported_dir,
>      }
>  
>      if (access(exported_dir, R_OK | X_OK)) {
> -        error_setg(errp, "Error accessing shared directory '%s': %s",
> -                   exported_dir, strerror(errno));
> +        error_setg_errno(errp, errno,
> +                         "Error accessing shared directory '%s'",
> +                         exported_dir);
>          return -1;
>      }
>  
> diff --git a/qga/commands-posix-ssh.c b/qga/commands-posix-ssh.c
> index 246171d323..661972e34e 100644
> --- a/qga/commands-posix-ssh.c
> +++ b/qga/commands-posix-ssh.c
> @@ -61,20 +61,22 @@ mkdir_for_user(const char *path, const struct passwd *p,
>                 mode_t mode, Error **errp)
>  {
>      if (g_mkdir(path, mode) == -1) {
> -        error_setg(errp, "failed to create directory '%s': %s",
> -                   path, g_strerror(errno));
> +        error_setg_errno(errp, errno, "failed to create directory '%s'",
> +                         path);
>          return false;
>      }
>  
>      if (chown(path, p->pw_uid, p->pw_gid) == -1) {
> -        error_setg(errp, "failed to set ownership of directory '%s': %s",
> -                   path, g_strerror(errno));
> +        error_setg_errno(errp, errno,
> +                         "failed to set ownership of directory '%s'",
> +                         path);
>          return false;
>      }
>  
>      if (chmod(path, mode) == -1) {
> -        error_setg(errp, "failed to set permissions of directory '%s': %s",
> -                   path, g_strerror(errno));
> +        error_setg_errno(errp, errno,
> +                         "failed to set permissions of directory '%s'",
> +                         path);
>          return false;
>      }
>  
> @@ -95,14 +97,15 @@ write_authkeys(const char *path, const GStrv keys,
>      }
>  
>      if (chown(path, p->pw_uid, p->pw_gid) == -1) {
> -        error_setg(errp, "failed to set ownership of directory '%s': %s",
> -                   path, g_strerror(errno));
> +        error_setg_errno(errp, errno,
> +                         "failed to set ownership of directory '%s'",
> +                         path);
>          return false;
>      }
>  
>      if (chmod(path, 0600) == -1) {
> -        error_setg(errp, "failed to set permissions of '%s': %s",
> -                   path, g_strerror(errno));
> +        error_setg_errno(errp, errno, "failed to set permissions of '%s'",
> +                         path);
>          return false;
>      }
>  
> diff --git a/system/vl.c b/system/vl.c
> index 5091fe52d9..2ef5b4b3b2 100644
> --- a/system/vl.c
> +++ b/system/vl.c
> @@ -619,7 +619,7 @@ static int parse_add_fd(void *opaque, QemuOpts *opts, Error **errp)
>      }
>  #endif
>      if (dupfd == -1) {
> -        error_setg(errp, "error duplicating fd: %s", strerror(errno));
> +        error_setg_errno(errp, errno, "error duplicating fd");
>          return -1;
>      }
>  
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 43124bf1c7..3501b5d546 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2699,9 +2699,8 @@ int kvmppc_get_htab_fd(bool write, uint64_t index, Error **errp)
>  
>      ret = kvm_vm_ioctl(kvm_state, KVM_PPC_GET_HTAB_FD, &s);
>      if (ret < 0) {
> -        error_setg(errp, "Unable to open fd for %s HPT %s KVM: %s",
> -                   write ? "writing" : "reading", write ? "to" : "from",
> -                   strerror(errno));
> +        error_setg_errno(errp, errno, "Unable to open fd for %s HPT %s KVM",
> +                   write ? "writing" : "reading", write ? "to" : "from");
>          return -errno;
>      }
>  
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

