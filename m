Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3750B74B1C4
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 15:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjGGN3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 09:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjGGN3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 09:29:19 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8A741FF6
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 06:29:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73242D75;
        Fri,  7 Jul 2023 06:29:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B33C73F73F;
        Fri,  7 Jul 2023 06:29:14 -0700 (PDT)
Date:   Fri, 7 Jul 2023 14:29:12 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 2/4] Replace printf/fprintf with pr_*
 macros
Message-ID: <ZKgTKGgUtszsK0EM@monolith.localdoman>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-3-alexandru.elisei@arm.com>
 <20230704094636.GC3214657@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704094636.GC3214657@myrica>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Jul 04, 2023 at 10:46:36AM +0100, Jean-Philippe Brucker wrote:
> On Fri, Jun 30, 2023 at 02:31:32PM +0100, Alexandru Elisei wrote:
> > To prepare for allowing finer control over the messages that kvmtool
> > displays, replace printf() and fprintf() with the pr_* macros.
> > 
> > Minor changes were made to fix coding style issues that were pet peeves for
> > the author. And use pr_err() in kvm_cpu__init() instead of pr_warning() for
> > fatal errors.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Looks good, some small things below
> 
> > ---
> > I have my doubts about the change to kernel_usage_with_options(). I did
> > this way instead of replacing fprintf() with pr_err() because this is how
> > it would have looked like:
> > 
> >   Error: Could not find default kernel image in:
> >   Error: 	./bzImage
> >   Error: 	arch/arm64/boot/bzImage
> >   Error: 	../../arch/arm64/boot/bzImage
> >   Error: 	/boot/vmlinuz-6.4.0
> >   Error: 	/boot/bzImage-6.4.0
> 
> Up to you but I'd leave it simple like that if it's just to print an
> occasional error message, it looks alright to me.

I went back to using pr_err().

> 
> > 
> > And this is how it looks now:
> > 
> >   Error: Could not find default kernel image in:
> > 	./bzImage
> > 	arch/arm64/boot/bzImage
> > 	../../arch/arm64/boot/bzImage
> > 	/boot/vmlinuz-6.4.0
> > 	/boot/bzImage-6.4.0
> > 
> > That, and msg ends up being 5 * 4096 ~= 20k bytes in size.
> > Happy to come up with something else if this is not satisfactory.
> > 
> >  arm/gic.c       |  5 ++--
> >  builtin-run.c   | 68 ++++++++++++++++++++++++++++++++++---------------
> >  builtin-setup.c | 18 ++++++-------
> >  guest_compat.c  |  2 +-
> >  kvm-cpu.c       | 12 ++++-----
> >  mmio.c          | 10 ++++----
> >  virtio/core.c   |  6 ++---
> >  x86/ioport.c    | 11 ++++----
> >  8 files changed, 78 insertions(+), 54 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index a223a72cfeb9..0795e9509bf8 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -115,9 +115,8 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
> >  
> >  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
> >  	if (err) {
> > -		fprintf(stderr,
> > -			"GICv3 ITS requested, but kernel does not support it.\n");
> > -		fprintf(stderr, "Try --irqchip=gicv3 instead\n");
> > +		pr_err("GICv3 ITS requested, but kernel does not support it.");
> > +		pr_err("Try --irqchip=gicv3 instead");
> >  		return err;
> >  	}
> >  
> > diff --git a/builtin-run.c b/builtin-run.c
> > index bd0d0b9c2467..79d031777c26 100644
> > --- a/builtin-run.c
> > +++ b/builtin-run.c
> > @@ -271,12 +271,14 @@ static void *kvm_cpu_thread(void *arg)
> >  	return (void *) (intptr_t) 0;
> >  
> >  panic_kvm:
> > -	fprintf(stderr, "KVM exit reason: %u (\"%s\")\n",
> > +	pr_err("KVM exit reason: %u (\"%s\")",
> >  		current_kvm_cpu->kvm_run->exit_reason,
> >  		kvm_exit_reasons[current_kvm_cpu->kvm_run->exit_reason]);
> > -	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN)
> > -		fprintf(stderr, "KVM exit code: 0x%llu\n",
> > +
> > +	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN) {
> > +		pr_err("KVM exit code: 0x%llu",
> 
> Not your change but 0x%llu is wrong, it could be fixed here

Not sure what you mean, hardware_exit_reason is an u64, and it's cast to an
unsigned long long to avoid printf format specifier warnings.

And as far as I know, unsigned long long is at least 64bits according to
C99 (the only reference I was able to quickly find is LLONG_MIN being
defined as -(2^63 - 1)).

> 
> >  			(unsigned long long)current_kvm_cpu->kvm_run->hw.hardware_exit_reason);
> > +	}
> >  
> >  	kvm_cpu__set_debug_fd(STDOUT_FILENO);
> >  	kvm_cpu__show_registers(current_kvm_cpu);
> > @@ -310,28 +312,53 @@ static const char *default_vmlinux[] = {
> >  
> >  static void kernel_usage_with_options(void)
> >  {
> > -	const char **k;
> > +	const char *prelude = "Could not find default kernel image in:";
> >  	struct utsname uts;
> > +	char *msg, *tmp;
> > +	size_t msg_size;
> > +	const char **k;
> > +
> > +	/* Ignore NULL path in host_kernels. */
> > +	msg_size = PATH_MAX * (ARRAY_SIZE(host_kernels) - 1);
> > +	msg_size += PATH_MAX * (ARRAY_SIZE(default_kernels) - 1);
> > +	msg = calloc(msg_size, 1);
> > +	if (!msg)
> > +		die_perror("calloc");
> > +	tmp = msg;
> > +
> > +	snprintf(tmp, msg_size, "%s\n", prelude);
> > +	msg_size -= strlen(prelude) + 1;
> 
> msg_size didn't contain prelude

Removed all of this to use pr_err instead of fprint(stderr). Seems easier
this way, and less error prone.

> 
> > +	tmp += strlen(prelude) + 1;
> >  
> > -	fprintf(stderr, "Fatal: could not find default kernel image in:\n");
> >  	k = &default_kernels[0];
> >  	while (*k) {
> > -		fprintf(stderr, "\t%s\n", *k);
> > +		if (snprintf(tmp, msg_size, "\t%s\n", *k) < 0)
> > +			goto out;
> > +		msg_size -= strlen(*k) + 2;
> > +		tmp += strlen(*k) + 2;
> >  		k++;
> >  	}
> >  
> >  	if (uname(&uts) < 0)
> > -		return;
> > +		goto out;
> >  
> >  	k = &host_kernels[0];
> >  	while (*k) {
> >  		if (snprintf(kernel, PATH_MAX, "%s-%s", *k, uts.release) < 0)
> > -			return;
> > -		fprintf(stderr, "\t%s\n", kernel);
> > +			goto out;
> > +		if (snprintf(tmp, msg_size, "\t%s\n", kernel) < 0)
> > +			goto out;
> > +		msg_size -= strlen(kernel) + 2;
> > +		tmp += strlen(kernel) + 2;
> >  		k++;
> >  	}
> > -	fprintf(stderr, "\nPlease see '%s run --help' for more options.\n\n",
> > +out:
> > +	/* Remove trailing newline - pr_err() will add its own. */
> > +	msg[strlen(msg) - 1] = '\0';
> > +	pr_err("%s", msg);
> > +	pr_info("Please see '%s run --help' for more options.",
> >  		KVM_BINARY_NAME);
> > +	free(msg);
> >  }
> >  
> >  static u64 host_ram_size(void)
> > @@ -656,8 +683,7 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
> >  
> >  			if ((kvm_run_wrapper == KVM_RUN_DEFAULT && kvm->cfg.kernel_filename) ||
> >  				(kvm_run_wrapper == KVM_RUN_SANDBOX && kvm->cfg.sandbox)) {
> > -				fprintf(stderr, "Cannot handle parameter: "
> > -						"%s\n", argv[0]);
> > +				pr_err("Cannot handle parameter: %s", argv[0]);
> >  				usage_with_options(run_usage, options);
> >  				free(kvm);
> >  				return ERR_PTR(-EINVAL);
> > @@ -775,15 +801,15 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
> >  		kvm_run_set_real_cmdline(kvm);
> >  
> >  	if (kvm->cfg.kernel_filename) {
> > -		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
> > -		       kvm->cfg.kernel_filename,
> > -		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> > -		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
> > +		pr_info("# %s run -k %s -m %Lu -c %d --name %s", KVM_BINARY_NAME,
> > +			kvm->cfg.kernel_filename,
> > +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> > +			kvm->cfg.nrcpus, kvm->cfg.guest_name);
> >  	} else if (kvm->cfg.firmware_filename) {
> > -		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
> > -		       kvm->cfg.firmware_filename,
> > -		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> > -		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
> > +		pr_info("# %s run --firmware %s -m %Lu -c %d --name %s", KVM_BINARY_NAME,
> > +			kvm->cfg.firmware_filename,
> > +			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
> > +			kvm->cfg.nrcpus, kvm->cfg.guest_name);
> >  	}
> >  
> >  	if (init_list__init(kvm) < 0)
> > @@ -815,7 +841,7 @@ static void kvm_cmd_run_exit(struct kvm *kvm, int guest_ret)
> >  	init_list__exit(kvm);
> >  
> >  	if (guest_ret == 0)
> > -		printf("\n  # KVM session ended normally.\n");
> > +		pr_info("KVM session ended normally.");
> >  }
> >  
> >  int kvm_cmd_run(int argc, const char **argv, const char *prefix)
> > diff --git a/builtin-setup.c b/builtin-setup.c
> > index b24d2a18921e..c333ae064b21 100644
> > --- a/builtin-setup.c
> > +++ b/builtin-setup.c
> > @@ -271,15 +271,15 @@ int kvm_cmd_setup(int argc, const char **argv, const char *prefix)
> >  		kvm_setup_help();
> >  
> >  	r = do_setup(instance_name);
> > -	if (r == 0)
> > -		printf("A new rootfs '%s' has been created in '%s%s'.\n\n"
> > -			"You can now start it by running the following command:\n\n"
> > -			"  %s run -d %s\n",
> > -			instance_name, kvm__get_dir(), instance_name,
> > -			KVM_BINARY_NAME,instance_name);
> > -	else
> > -		printf("Unable to create rootfs in %s%s: %s\n",
> > -			kvm__get_dir(), instance_name, strerror(errno));
> > +	if (r == 0) {
> > +		pr_info("A new rootfs '%s' has been created in '%s%s'.",
> > +			instance_name, kvm__get_dir(), instance_name);
> > +		pr_info("You can now start it by running the following command:");
> > +		pr_info("%s run -d %s", KVM_BINARY_NAME, instance_name);
> 
> Above uses '#' as prefix for a lkvm command, maybe we could keep it
> consistent
> 
> > +	} else {
> > +		pr_err("Unable to create rootfs in %s%s: %s",
> > +		       kvm__get_dir(), instance_name, strerror(errno));
> > +	}
> >  
> >  	return r;
> >  }
> > diff --git a/guest_compat.c b/guest_compat.c
> > index fd4704b20b16..93f9aabcd6db 100644
> > --- a/guest_compat.c
> > +++ b/guest_compat.c
> > @@ -86,7 +86,7 @@ int compat__print_all_messages(void)
> >  
> >  		msg = list_first_entry(&messages, struct compat_message, list);
> >  
> > -		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
> > +		pr_warning("KVM compatibility warning.\n\t%s\n\t%s",
> >  			msg->title, msg->desc);
> >  
> >  		list_del(&msg->list);
> > diff --git a/kvm-cpu.c b/kvm-cpu.c
> > index 7dec08894cd3..1c566b3f21d6 100644
> > --- a/kvm-cpu.c
> > +++ b/kvm-cpu.c
> > @@ -265,32 +265,32 @@ int kvm_cpu__init(struct kvm *kvm)
> >  	recommended_cpus = kvm__recommended_cpus(kvm);
> >  
> >  	if (kvm->cfg.nrcpus > max_cpus) {
> > -		printf("  # Limit the number of CPUs to %d\n", max_cpus);
> > +		pr_warning("Limiting the number of CPUs to %d", max_cpus);
> >  		kvm->cfg.nrcpus = max_cpus;
> >  	} else if (kvm->cfg.nrcpus > recommended_cpus) {
> > -		printf("  # Warning: The maximum recommended amount of VCPUs"
> > -			" is %d\n", recommended_cpus);
> > +		pr_warning("The maximum recommended amount of VCPUs is %d",
> > +			   recommended_cpus);
> >  	}
> >  
> >  	kvm->nrcpus = kvm->cfg.nrcpus;
> >  
> >  	task_eventfd = eventfd(0, 0);
> >  	if (task_eventfd < 0) {
> > -		pr_warning("Couldn't create task_eventfd");
> > +		pr_err("Couldn't create task_eventfd");
> >  		return task_eventfd;
> >  	}
> >  
> >  	/* Alloc one pointer too many, so array ends up 0-terminated */
> >  	kvm->cpus = calloc(kvm->nrcpus + 1, sizeof(void *));
> >  	if (!kvm->cpus) {
> > -		pr_warning("Couldn't allocate array for %d CPUs", kvm->nrcpus);
> > +		pr_err("Couldn't allocate array for %d CPUs", kvm->nrcpus);
> >  		return -ENOMEM;
> >  	}
> >  
> >  	for (i = 0; i < kvm->nrcpus; i++) {
> >  		kvm->cpus[i] = kvm_cpu__arch_init(kvm, i);
> >  		if (!kvm->cpus[i]) {
> > -			pr_warning("unable to initialize KVM VCPU");
> > +			pr_err("unable to initialize KVM VCPU");
> >  			goto fail_alloc;
> >  		}
> >  	}
> > diff --git a/mmio.c b/mmio.c
> > index 5a114e9997d9..d9a09565185c 100644
> > --- a/mmio.c
> > +++ b/mmio.c
> > @@ -203,9 +203,9 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
> >  	mmio = mmio_get(&mmio_tree, phys_addr, len);
> >  	if (!mmio) {
> >  		if (vcpu->kvm->cfg.mmio_debug)
> > -			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
> > -				to_direction(is_write),
> > -				(unsigned long long)phys_addr, len);
> > +			pr_warning("Warning: Ignoring MMIO %s at %016llx (length %u)",
> 
> "Warning:" is redundant

I've reverted this change, for the same reason I reverted the ioport change
(it's a separate debug option).

Also replaced "Warning" with "IO warning" to be consistent with "IO error"
below and to make it clear that it's separate from the pr_* messages ( it's
not toggled with a --loglevel level).

> 
> > +				   to_direction(is_write),
> > +				   (unsigned long long)phys_addr, len);
> >  		goto out;
> >  	}
> >  
> > @@ -225,8 +225,8 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
> >  	mmio = mmio_get(&pio_tree, port, size);
> >  	if (!mmio) {
> >  		if (vcpu->kvm->cfg.ioport_debug) {
> > -			fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n",
> > -				to_direction(direction), port, size, count);
> > +			pr_warning("IO error: %s port=%x, size=%d, count=%u",
> > +				   to_direction(direction), port, size, count);
> >  
> >  			return false;
> >  		}
> > diff --git a/virtio/core.c b/virtio/core.c
> > index a77e23bc9b34..c4e79c7a3d40 100644
> > --- a/virtio/core.c
> > +++ b/virtio/core.c
> > @@ -417,10 +417,10 @@ int virtio_compat_add_message(const char *device, const char *config)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	snprintf(title, len, "%s device was not detected.", device);
> > -	snprintf(desc,  len, "While you have requested a %s device, "
> > +	snprintf(title, len, "   %s device was not detected.", device);
> > +	snprintf(desc,  len, "   While you have requested a %s device, "
> 
> Spaces seem redundant since there already is a \t prefix. I get this is to
> align with "Warning:" but tab size can vary depending on the terminal.

Done.

> 
> >  			     "the guest kernel did not initialize it.\n"
> > -			     "\tPlease make sure that the guest kernel was "
> > +			     "\t   Please make sure that the guest kernel was "
> >  			     "compiled with %s=y enabled in .config.",
> >  			     device, config);
> >  
> > diff --git a/x86/ioport.c b/x86/ioport.c
> > index 06b7defbaae8..0f1a857483c1 100644
> > --- a/x86/ioport.c
> > +++ b/x86/ioport.c
> > @@ -14,9 +14,10 @@ static void debug_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >  	if (!vcpu->kvm->cfg.ioport_debug)
> >  		return;
> >  
> > -	fprintf(stderr, "debug port %s from VCPU%lu: port=0x%lx, size=%u",
> > -		is_write ? "write" : "read", vcpu->cpu_id,
> > -		(unsigned long)addr, len);
> > +	pr_debug("debug port %s from VCPU%lu: port=0x%lx, size=%u",
> > +		 is_write ? "write" : "read", vcpu->cpu_id,
> > +		 (unsigned long)addr, len);
> > +
> 
> This one is different: user enables ioport debugging with --debug-ioport
> and expects to see these messages, even if loglevel < debug which is the
> default. I think it should remain fprintf(). Though to be honest I don't
> know if this is still supposed to work, currently kvm__emulate_io() exits
> on the first ioport access when --debug-ioport is enabled.

Agreed, I've reverted this change.

Thanks,
Alex

> 
> Thanks,
> Jean
> 
> >  	if (is_write) {
> >  		u32 value;
> >  
> > @@ -26,9 +27,7 @@ static void debug_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
> >  		case 4: value = ioport__read32((u32*)data); break;
> >  		default: value = 0; break;
> >  		}
> > -		fprintf(stderr, ", data: 0x%x\n", value);
> > -	} else {
> > -		fprintf(stderr, "\n");
> > +		pr_debug("data: 0x%x", value);
> >  	}
> >  }
> >  
> > -- 
> > 2.41.0
> > 
