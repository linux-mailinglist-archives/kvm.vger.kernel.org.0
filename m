Return-Path: <kvm+bounces-64019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C591C76C59
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8305B4E4CFA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C73224A06D;
	Fri, 21 Nov 2025 00:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="M+mrJZyL"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C3626D4C7
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684636; cv=none; b=YBrWMsKrETcLEBegnv1Rot5caF2/MAVzHHAW66zDab9WRxULeZwo9V8pyxpP5OkLecJtOsdqZuWo+N7dJev6M3J2Bn2wCOUgkIoGfK44uEUhbD+KRysrmSo+XqBvpk1mwtmyluTi82/RS7Tw0qFTyasuqYBdO632RrBZZxSwlgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684636; c=relaxed/simple;
	bh=3gw7s3DqJOdM5BTLX/FpZmp5CBMJxHrBk0dd3tGRoWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVS/CgrXp6mrSTlrqsMxtm11b1RqFPPmcnZQ5t1sBmRq26J/bU9XWlcLKbJ8/pv14ssEAlviOXQ5cpkSPLvmHBDr/EwWuVDJ8/sdIGfyOJVq1F5bgGNdLrkGD+6vV/KSq+htPJzCpSipiF7Qfdp7IiFi+hhnDz8cWq3/ivRLZaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=M+mrJZyL; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=yLx8/kW/v6qUU6G/CxjaSljuRBbP90sLxOMR5Nm0pKA=; b=M+mrJZyL7werI5IY
	QaTeVA66JNcc6UmKX+IWfgWcCWSuWyHR7woCz+nK9VH5X6DShYGi0MnnpKdk9R3hWP01DVM9pwSO+
	0mHysCZkXmXtBm6gneQIoDYy329cHrq4QWGf+FTXK+uautA8L/u+kRXnHzpnKt8s9QlXtYFuaryRY
	wSIAGNeeevUTUeh/kN6c9EILJCGBnAqKriOxG+2PqaiaQF12+cH853scKM7WMr9MfwqCtDgaZNVtO
	gXnSKivBzAdvYq5xjXyQrtWf62qjquyoFcKQ+Ozoj8NzsmVeiTGM8WAQHu/FUVhGAqjlsbDzc600R
	s+g1gljwzFbH36fTkA==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMEWX-00000005cYr-0ztq;
	Thu, 20 Nov 2025 23:57:13 +0000
Date: Thu, 20 Nov 2025 23:57:13 +0000
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
Subject: Re: [PATCH 09/14] error: Use error_setg_file_open() for simplicity
 and consistency
Message-ID: <aR-q2YeegIEPmk2R@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-10-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-10-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 23:56:31 up 24 days, 23:32,  2 users,  load average: 0.00, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> Replace
> 
>     error_setg_errno(errp, errno, MSG, FNAME);
> 
> by
> 
>     error_setg_file_open(errp, errno, FNAME);
> 
> where MSG is "Could not open '%s'" or similar.
> 
> Also replace equivalent uses of error_setg().
> 
> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
> We could put them back with error_prepend().  Not worth the bother.

Yeh, I guess you could just do it with another macro using
the same internal function just with string concatenation.

> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  hw/9pfs/9p-local.c        | 2 +-
>  hw/acpi/core.c            | 2 +-
>  hw/core/loader.c          | 2 +-
>  hw/pci-host/xen_igd_pt.c  | 2 +-
>  monitor/hmp-cmds-target.c | 2 +-
>  net/dump.c                | 2 +-
>  net/tap-bsd.c             | 6 +++---
>  net/tap-linux.c           | 2 +-
>  target/i386/sev.c         | 6 ++----
>  ui/ui-qmp-cmds.c          | 3 +--
>  util/vfio-helpers.c       | 5 ++---
>  11 files changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/9pfs/9p-local.c b/hw/9pfs/9p-local.c
> index 31e216227c..376b377698 100644
> --- a/hw/9pfs/9p-local.c
> +++ b/hw/9pfs/9p-local.c
> @@ -1456,7 +1456,7 @@ static int local_init(FsContext *ctx, Error **errp)
>  
>      data->mountfd = open(ctx->fs_root, O_DIRECTORY | O_RDONLY);
>      if (data->mountfd == -1) {
> -        error_setg_errno(errp, errno, "failed to open '%s'", ctx->fs_root);
> +        error_setg_file_open(errp, errno, ctx->fs_root);
>          goto err;
>      }
>  
> diff --git a/hw/acpi/core.c b/hw/acpi/core.c
> index ff16582803..d2677332af 100644
> --- a/hw/acpi/core.c
> +++ b/hw/acpi/core.c
> @@ -277,7 +277,7 @@ void acpi_table_add(const QemuOpts *opts, Error **errp)
>          int fd = open(*cur, O_RDONLY | O_BINARY);
>  
>          if (fd < 0) {
> -            error_setg(errp, "can't open file %s: %s", *cur, strerror(errno));
> +            error_setg_file_open(errp, errno, *cur);
>              goto out;
>          }
>  
> diff --git a/hw/core/loader.c b/hw/core/loader.c
> index 590c5b02aa..b56e5eb2f5 100644
> --- a/hw/core/loader.c
> +++ b/hw/core/loader.c
> @@ -379,7 +379,7 @@ void load_elf_hdr(const char *filename, void *hdr, bool *is64, Error **errp)
>  
>      fd = open(filename, O_RDONLY | O_BINARY);
>      if (fd < 0) {
> -        error_setg_errno(errp, errno, "Failed to open file: %s", filename);
> +        error_setg_file_open(errp, errno, filename);
>          return;
>      }
>      if (read(fd, hdr, EI_NIDENT) != EI_NIDENT) {
> diff --git a/hw/pci-host/xen_igd_pt.c b/hw/pci-host/xen_igd_pt.c
> index 5dd17ef236..f6016f2cd5 100644
> --- a/hw/pci-host/xen_igd_pt.c
> +++ b/hw/pci-host/xen_igd_pt.c
> @@ -55,7 +55,7 @@ static void host_pci_config_read(int pos, int len, uint32_t *val, Error **errp)
>  
>      config_fd = open(path, O_RDWR);
>      if (config_fd < 0) {
> -        error_setg_errno(errp, errno, "Failed to open: %s", path);
> +        error_setg_file_open(errp, errno, path);
>          goto out;
>      }
>  
> diff --git a/monitor/hmp-cmds-target.c b/monitor/hmp-cmds-target.c
> index e982061146..ad4ed2167d 100644
> --- a/monitor/hmp-cmds-target.c
> +++ b/monitor/hmp-cmds-target.c
> @@ -331,7 +331,7 @@ static uint64_t vtop(void *ptr, Error **errp)
>  
>      fd = open("/proc/self/pagemap", O_RDONLY);
>      if (fd == -1) {
> -        error_setg_errno(errp, errno, "Cannot open /proc/self/pagemap");
> +        error_setg_file_open(errp, errno, "/proc/self/pagemap");
>          return -1;
>      }
>  
> diff --git a/net/dump.c b/net/dump.c
> index 581234b775..0c39f09892 100644
> --- a/net/dump.c
> +++ b/net/dump.c
> @@ -111,7 +111,7 @@ static int net_dump_state_init(DumpState *s, const char *filename,
>  
>      fd = open(filename, O_CREAT | O_TRUNC | O_WRONLY | O_BINARY, 0644);
>      if (fd < 0) {
> -        error_setg_errno(errp, errno, "net dump: can't open %s", filename);
> +        error_setg_file_open(errp, errno, filename);
>          return -1;
>      }
>  
> diff --git a/net/tap-bsd.c b/net/tap-bsd.c
> index bbf84d1828..3fd300d46f 100644
> --- a/net/tap-bsd.c
> +++ b/net/tap-bsd.c
> @@ -68,7 +68,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
>          }
>      }
>      if (fd < 0) {
> -        error_setg_errno(errp, errno, "could not open %s", dname);
> +        error_setg_file_open(errp, errno, dname);
>          return -1;
>      }
>  
> @@ -118,7 +118,7 @@ static int tap_open_clone(char *ifname, int ifname_size, Error **errp)
>  
>      fd = RETRY_ON_EINTR(open(PATH_NET_TAP, O_RDWR));
>      if (fd < 0) {
> -        error_setg_errno(errp, errno, "could not open %s", PATH_NET_TAP);
> +        error_setg_file_open(errp, errno, PATH_NET_TAP);
>          return -1;
>      }
>  
> @@ -166,7 +166,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
>          snprintf(dname, sizeof dname, "/dev/%s", ifname);
>          fd = RETRY_ON_EINTR(open(dname, O_RDWR));
>          if (fd < 0 && errno != ENOENT) {
> -            error_setg_errno(errp, errno, "could not open %s", dname);
> +            error_setg_file_open(errp, errno, dname);
>              return -1;
>          }
>      }
> diff --git a/net/tap-linux.c b/net/tap-linux.c
> index 2a90b58467..909c4f1fcf 100644
> --- a/net/tap-linux.c
> +++ b/net/tap-linux.c
> @@ -57,7 +57,7 @@ int tap_open(char *ifname, int ifname_size, int *vnet_hdr,
>      if (fd < 0) {
>          fd = RETRY_ON_EINTR(open(PATH_NET_TUN, O_RDWR));
>          if (fd < 0) {
> -            error_setg_errno(errp, errno, "could not open %s", PATH_NET_TUN);
> +            error_setg_file_open(errp, errno, PATH_NET_TUN);
>              return -1;
>          }
>      }
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index fd2dada013..8660ecd9e4 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -891,8 +891,7 @@ static SevCapability *sev_get_capabilities(Error **errp)
>  
>      fd = open(sev_device, O_RDWR);
>      if (fd < 0) {
> -        error_setg_errno(errp, errno, "SEV: Failed to open %s",
> -                         sev_device);
> +        error_setg_file_open(errp, errno, sev_device);
>          g_free(sev_device);
>          return NULL;
>      }
> @@ -1819,8 +1818,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      devname = object_property_get_str(OBJECT(sev_common), "sev-device", NULL);
>      sev_common->sev_fd = open(devname, O_RDWR);
>      if (sev_common->sev_fd < 0) {
> -        error_setg(errp, "%s: Failed to open %s '%s'", __func__,
> -                   devname, strerror(errno));
> +        error_setg_file_open(errp, errno, devname);
>          g_free(devname);
>          return -1;
>      }
> diff --git a/ui/ui-qmp-cmds.c b/ui/ui-qmp-cmds.c
> index 74fa6c6ec5..d927121676 100644
> --- a/ui/ui-qmp-cmds.c
> +++ b/ui/ui-qmp-cmds.c
> @@ -371,8 +371,7 @@ qmp_screendump(const char *filename, const char *device,
>  
>      fd = qemu_open_old(filename, O_WRONLY | O_CREAT | O_TRUNC | O_BINARY, 0666);
>      if (fd == -1) {
> -        error_setg(errp, "failed to open file '%s': %s", filename,
> -                   strerror(errno));
> +        error_setg_file_open(errp, errno, filename);
>          return;
>      }
>  
> diff --git a/util/vfio-helpers.c b/util/vfio-helpers.c
> index fdff042ab4..8b1b2e2f05 100644
> --- a/util/vfio-helpers.c
> +++ b/util/vfio-helpers.c
> @@ -309,7 +309,7 @@ static int qemu_vfio_init_pci(QEMUVFIOState *s, const char *device,
>      s->container = open("/dev/vfio/vfio", O_RDWR);
>  
>      if (s->container == -1) {
> -        error_setg_errno(errp, errno, "Failed to open /dev/vfio/vfio");
> +        error_setg_file_open(errp, errno, "/dev/vfio/vfio");
>          return -errno;
>      }
>      if (ioctl(s->container, VFIO_GET_API_VERSION) != VFIO_API_VERSION) {
> @@ -333,8 +333,7 @@ static int qemu_vfio_init_pci(QEMUVFIOState *s, const char *device,
>  
>      s->group = open(group_file, O_RDWR);
>      if (s->group == -1) {
> -        error_setg_errno(errp, errno, "Failed to open VFIO group file: %s",
> -                         group_file);
> +        error_setg_file_open(errp, errno, group_file);
>          g_free(group_file);
>          ret = -errno;
>          goto fail_container;
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

