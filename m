Return-Path: <kvm+bounces-68454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4413BD39C3A
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:04:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1309430019E1
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8891E531;
	Mon, 19 Jan 2026 02:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="QlS/axA5"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFBB221FBD
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768788230; cv=none; b=gdy/jKIIo7XzL8G75I/ShZx9vvDLRDQ5D5sOYsSesoPpJF5L4LYgwWK6Cs9+E2XBbth3atEkYeWN55vFIS+537DeLHKwzMu2KAVkQhUadaXc2+V1wZYgTJQjqC5aE0N+YnNTB70ILgsMDtg6W8sbpLkUQnsPk6BaixrkBPGyjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768788230; c=relaxed/simple;
	bh=g4c4GndvDhP8Hk1th/kLA7bGy5ojpNpCOxgg5G6y6XI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCQQpVuW0TVIxVOenVsY6TZS3LjIGEiEE39OzPcgF3/AYdhqu7IKM2GCQjshoPSVhI7Ppd8DAlMzjVx1T6ijjkTowRcgGZeXLmsc75a7RFpH6sSw3bwH35Vqb64mdy+1CuhwSY7lnmhSXl1WzPeSN7jAHfJQaSmhKMOqfUKYWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=QlS/axA5; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=78eqqM/Ivvh0sbPhGOXcjk1eqzXwIry2+Dfl3wq3Hew=; b=QlS/axA5ce8Y3/V+
	Vv/MPienM/qGooUkLfH3c0X0uIJDguXrSPJQdQMMlNw5XQVYuuDE9gNONn5J3j3HmOuoj3J/kJN2c
	FL4UxGzD59OdLDdmZ+AIOcAWdGjQBM8I3fx8qPcYkwKfVYtpEh5Q0tm4XHOGccdmijSJSm/d4mrDv
	QryEai63Li4OWz1u/poBIzLXwxIB0c6ErsLNRPqjJ4nOd7fkMagRdw9GG6ULtyVjG1PfzZgFQcjG8
	WdAgUDdGb5Ay5TnlXFYI1wX616X8SVg8fmxygiLqytu8A41aOsmo1+vFzi+ePSu5Ejm+IOHawDv3v
	MzGXlT9JdGdejLTaNQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vheby-0000000Ff6o-0uIB;
	Mon, 19 Jan 2026 02:03:22 +0000
Date: Mon, 19 Jan 2026 02:03:22 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>, kvm@vger.kernel.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org
Subject: Re: [PATCH v2 8/8] monitor: Remove 'monitor/hmp-target.h' header
Message-ID: <aW2Q6pjYU9UCQ0Ks@gallifrey>
References: <20260117162926.74225-1-philmd@linaro.org>
 <20260117162926.74225-9-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260117162926.74225-9-philmd@linaro.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 02:03:18 up 84 days,  1:39,  3 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Philippe Mathieu-Daudé (philmd@linaro.org) wrote:
> The "monitor/hmp-target.h" header doesn't contain any
> target-specific declarations anymore. Merge it with
> "monitor/hmp.h", its target-agnostic counterpart.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  MAINTAINERS                   |  2 +-
>  include/monitor/hmp-target.h  | 60 -----------------------------------
>  include/monitor/hmp.h         | 31 ++++++++++++++++++
>  hw/i386/sgx-stub.c            |  2 +-
>  hw/i386/sgx.c                 |  1 -
>  monitor/hmp-cmds.c            |  1 -
>  monitor/hmp-target.c          |  1 -
>  monitor/hmp.c                 |  1 -
>  stubs/target-monitor-defs.c   |  2 +-
>  target/i386/cpu-apic.c        |  2 +-
>  target/i386/monitor.c         |  1 -
>  target/i386/sev-system-stub.c |  2 +-
>  target/i386/sev.c             |  1 -
>  target/m68k/monitor.c         |  2 +-
>  target/ppc/ppc-qmp-cmds.c     |  1 -
>  target/riscv/monitor.c        |  2 +-
>  target/riscv/riscv-qmp-cmds.c |  1 -
>  target/sh4/monitor.c          |  1 -
>  target/sparc/monitor.c        |  1 -
>  target/xtensa/monitor.c       |  1 -
>  20 files changed, 38 insertions(+), 78 deletions(-)
>  delete mode 100644 include/monitor/hmp-target.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index de8246c3ffd..1e0d71c7bb8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3377,7 +3377,7 @@ F: monitor/monitor.c
>  F: monitor/hmp*
>  F: hmp.h
>  F: hmp-commands*.hx
> -F: include/monitor/hmp-target.h
> +F: include/monitor/hmp.h
>  F: tests/qtest/test-hmp.c
>  F: include/qemu/qemu-print.h
>  F: util/qemu-print.c
> diff --git a/include/monitor/hmp-target.h b/include/monitor/hmp-target.h
> deleted file mode 100644
> index 713936c4523..00000000000
> --- a/include/monitor/hmp-target.h
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -/*
> - * QEMU monitor
> - *
> - * Copyright (c) 2003-2004 Fabrice Bellard
> - *
> - * Permission is hereby granted, free of charge, to any person obtaining a copy
> - * of this software and associated documentation files (the "Software"), to deal
> - * in the Software without restriction, including without limitation the rights
> - * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> - * copies of the Software, and to permit persons to whom the Software is
> - * furnished to do so, subject to the following conditions:
> - *
> - * The above copyright notice and this permission notice shall be included in
> - * all copies or substantial portions of the Software.
> - *
> - * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> - * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> - * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
> - * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> - * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> - * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> - * THE SOFTWARE.
> - */
> -
> -#ifndef MONITOR_HMP_TARGET_H
> -#define MONITOR_HMP_TARGET_H
> -
> -typedef struct MonitorDef MonitorDef;
> -
> -struct MonitorDef {
> -    const char *name;
> -    int offset;
> -    uint64_t (*get_value)(Monitor *mon, const struct MonitorDef *md, int val);
> -    int type;
> -};
> -
> -#define MD_TLONG 0
> -#define MD_I32   1
> -
> -const MonitorDef *target_monitor_defs(void);
> -int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval);
> -
> -CPUArchState *mon_get_cpu_env(Monitor *mon);
> -CPUState *mon_get_cpu(Monitor *mon);
> -
> -void hmp_info_mem(Monitor *mon, const QDict *qdict);
> -void hmp_info_tlb(Monitor *mon, const QDict *qdict);
> -void hmp_mce(Monitor *mon, const QDict *qdict);
> -void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
> -void hmp_info_sev(Monitor *mon, const QDict *qdict);
> -void hmp_info_sgx(Monitor *mon, const QDict *qdict);
> -void hmp_info_via(Monitor *mon, const QDict *qdict);
> -void hmp_memory_dump(Monitor *mon, const QDict *qdict);
> -void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict);
> -void hmp_info_registers(Monitor *mon, const QDict *qdict);
> -void hmp_gva2gpa(Monitor *mon, const QDict *qdict);
> -void hmp_gpa2hva(Monitor *mon, const QDict *qdict);
> -void hmp_gpa2hpa(Monitor *mon, const QDict *qdict);
> -
> -#endif /* MONITOR_HMP_TARGET_H */
> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
> index 83721b5ffc6..fb678786101 100644
> --- a/include/monitor/hmp.h
> +++ b/include/monitor/hmp.h
> @@ -17,6 +17,37 @@
>  #include "qemu/readline.h"
>  #include "qapi/qapi-types-common.h"
>  
> +typedef struct MonitorDef {
> +    const char *name;
> +    int offset;
> +    uint64_t (*get_value)(Monitor *mon, const struct MonitorDef *md, int val);
> +    int type;
> +} MonitorDef;
> +
> +#define MD_TLONG 0
> +#define MD_I32   1
> +
> +const MonitorDef *target_monitor_defs(void);
> +
> +int target_get_monitor_def(CPUState *cs, const char *name, uint64_t *pval);
> +
> +CPUArchState *mon_get_cpu_env(Monitor *mon);
> +CPUState *mon_get_cpu(Monitor *mon);
> +
> +void hmp_info_mem(Monitor *mon, const QDict *qdict);
> +void hmp_info_tlb(Monitor *mon, const QDict *qdict);
> +void hmp_mce(Monitor *mon, const QDict *qdict);
> +void hmp_info_local_apic(Monitor *mon, const QDict *qdict);
> +void hmp_info_sev(Monitor *mon, const QDict *qdict);
> +void hmp_info_sgx(Monitor *mon, const QDict *qdict);
> +void hmp_info_via(Monitor *mon, const QDict *qdict);
> +void hmp_memory_dump(Monitor *mon, const QDict *qdict);
> +void hmp_physical_memory_dump(Monitor *mon, const QDict *qdict);
> +void hmp_info_registers(Monitor *mon, const QDict *qdict);
> +void hmp_gva2gpa(Monitor *mon, const QDict *qdict);
> +void hmp_gpa2hva(Monitor *mon, const QDict *qdict);
> +void hmp_gpa2hpa(Monitor *mon, const QDict *qdict);
> +
>  bool hmp_handle_error(Monitor *mon, Error *err);
>  void hmp_help_cmd(Monitor *mon, const char *name);
>  strList *hmp_split_at_comma(const char *str);
> diff --git a/hw/i386/sgx-stub.c b/hw/i386/sgx-stub.c
> index d295e54d239..6e82773a86d 100644
> --- a/hw/i386/sgx-stub.c
> +++ b/hw/i386/sgx-stub.c
> @@ -1,6 +1,6 @@
>  #include "qemu/osdep.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  #include "hw/i386/pc.h"
>  #include "hw/i386/sgx-epc.h"
>  #include "qapi/qapi-commands-misc-i386.h"
> diff --git a/hw/i386/sgx.c b/hw/i386/sgx.c
> index e2801546ad6..54d2cae36d8 100644
> --- a/hw/i386/sgx.c
> +++ b/hw/i386/sgx.c
> @@ -16,7 +16,6 @@
>  #include "hw/mem/memory-device.h"
>  #include "monitor/qdev.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "qapi/error.h"
>  #include "qemu/error-report.h"
>  #include "qapi/qapi-commands-misc-i386.h"
> diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
> index 5a673cddb2a..7c2b69dfa5b 100644
> --- a/monitor/hmp-cmds.c
> +++ b/monitor/hmp-cmds.c
> @@ -21,7 +21,6 @@
>  #include "gdbstub/enums.h"
>  #include "monitor/hmp.h"
>  #include "qemu/help_option.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/monitor-internal.h"
>  #include "qapi/error.h"
>  #include "qapi/qapi-commands-control.h"
> diff --git a/monitor/hmp-target.c b/monitor/hmp-target.c
> index a3306b69c93..2574c5d8b4b 100644
> --- a/monitor/hmp-target.c
> +++ b/monitor/hmp-target.c
> @@ -27,7 +27,6 @@
>  #include "monitor/qdev.h"
>  #include "net/slirp.h"
>  #include "system/device_tree.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  #include "block/block-hmp-cmds.h"
>  #include "qapi/qapi-commands-control.h"
> diff --git a/monitor/hmp.c b/monitor/hmp.c
> index 82d2bbdf77d..4dc8c5f9364 100644
> --- a/monitor/hmp.c
> +++ b/monitor/hmp.c
> @@ -27,7 +27,6 @@
>  #include "hw/core/qdev.h"
>  #include "monitor-internal.h"
>  #include "monitor/hmp.h"
> -#include "monitor/hmp-target.h"
>  #include "qobject/qdict.h"
>  #include "qobject/qnum.h"
>  #include "qemu/bswap.h"
> diff --git a/stubs/target-monitor-defs.c b/stubs/target-monitor-defs.c
> index 35a0a342772..0dd4cdb34f6 100644
> --- a/stubs/target-monitor-defs.c
> +++ b/stubs/target-monitor-defs.c
> @@ -1,5 +1,5 @@
>  #include "qemu/osdep.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  
>  const MonitorDef *target_monitor_defs(void)
>  {
> diff --git a/target/i386/cpu-apic.c b/target/i386/cpu-apic.c
> index eeee62b52a2..3b73a04597f 100644
> --- a/target/i386/cpu-apic.c
> +++ b/target/i386/cpu-apic.c
> @@ -10,7 +10,7 @@
>  #include "qobject/qdict.h"
>  #include "qapi/error.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  #include "system/hw_accel.h"
>  #include "system/kvm.h"
>  #include "system/xen.h"
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index cce23f987ef..1c16b003371 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -25,7 +25,6 @@
>  #include "qemu/osdep.h"
>  #include "cpu.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  #include "qobject/qdict.h"
>  #include "qapi/error.h"
> diff --git a/target/i386/sev-system-stub.c b/target/i386/sev-system-stub.c
> index 7c5c02a5657..f799a338d60 100644
> --- a/target/i386/sev-system-stub.c
> +++ b/target/i386/sev-system-stub.c
> @@ -13,7 +13,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  #include "qapi/error.h"
>  #include "sev.h"
>  
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1d70f96ec1f..31dbabe4b51 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -36,7 +36,6 @@
>  #include "migration/blocker.h"
>  #include "qom/object.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "qapi/qapi-commands-misc-i386.h"
>  #include "confidential-guest.h"
>  #include "hw/i386/pc.h"
> diff --git a/target/m68k/monitor.c b/target/m68k/monitor.c
> index 161f41853ec..05d05440f42 100644
> --- a/target/m68k/monitor.c
> +++ b/target/m68k/monitor.c
> @@ -7,7 +7,7 @@
>  
>  #include "qemu/osdep.h"
>  #include "cpu.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  #include "monitor/monitor.h"
>  
>  void hmp_info_tlb(Monitor *mon, const QDict *qdict)
> diff --git a/target/ppc/ppc-qmp-cmds.c b/target/ppc/ppc-qmp-cmds.c
> index 07938abb15f..08314e3c1cd 100644
> --- a/target/ppc/ppc-qmp-cmds.c
> +++ b/target/ppc/ppc-qmp-cmds.c
> @@ -26,7 +26,6 @@
>  #include "cpu.h"
>  #include "monitor/monitor.h"
>  #include "qemu/ctype.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  #include "qapi/error.h"
>  #include "qapi/qapi-commands-machine.h"
> diff --git a/target/riscv/monitor.c b/target/riscv/monitor.c
> index 8a77476db93..bc176dd8771 100644
> --- a/target/riscv/monitor.c
> +++ b/target/riscv/monitor.c
> @@ -22,7 +22,7 @@
>  #include "cpu.h"
>  #include "cpu_bits.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
> +#include "monitor/hmp.h"
>  #include "system/memory.h"
>  
>  #ifdef TARGET_RISCV64
> diff --git a/target/riscv/riscv-qmp-cmds.c b/target/riscv/riscv-qmp-cmds.c
> index d5e9bec0f86..79232d34005 100644
> --- a/target/riscv/riscv-qmp-cmds.c
> +++ b/target/riscv/riscv-qmp-cmds.c
> @@ -34,7 +34,6 @@
>  #include "qemu/ctype.h"
>  #include "qemu/qemu-print.h"
>  #include "monitor/hmp.h"
> -#include "monitor/hmp-target.h"
>  #include "system/kvm.h"
>  #include "system/tcg.h"
>  #include "cpu-qom.h"
> diff --git a/target/sh4/monitor.c b/target/sh4/monitor.c
> index 2da6a5426eb..50324d3600c 100644
> --- a/target/sh4/monitor.c
> +++ b/target/sh4/monitor.c
> @@ -24,7 +24,6 @@
>  #include "qemu/osdep.h"
>  #include "cpu.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  
>  static void print_tlb(Monitor *mon, int idx, tlb_t *tlb)
> diff --git a/target/sparc/monitor.c b/target/sparc/monitor.c
> index 3e1f4dd5c9c..79f564c551a 100644
> --- a/target/sparc/monitor.c
> +++ b/target/sparc/monitor.c
> @@ -24,7 +24,6 @@
>  #include "qemu/osdep.h"
>  #include "cpu.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  
>  
> diff --git a/target/xtensa/monitor.c b/target/xtensa/monitor.c
> index fbf60d55530..2af84934f83 100644
> --- a/target/xtensa/monitor.c
> +++ b/target/xtensa/monitor.c
> @@ -24,7 +24,6 @@
>  #include "qemu/osdep.h"
>  #include "cpu.h"
>  #include "monitor/monitor.h"
> -#include "monitor/hmp-target.h"
>  #include "monitor/hmp.h"
>  
>  void hmp_info_tlb(Monitor *mon, const QDict *qdict)
> -- 
> 2.52.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

