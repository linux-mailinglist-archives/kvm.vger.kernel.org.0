Return-Path: <kvm+bounces-5977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B0182935F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 06:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58038289089
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 05:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B682DF59;
	Wed, 10 Jan 2024 05:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rAIiSnmz"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337FC3C2F
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 05:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 10 Jan 2024 14:40:01 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704865217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nP4QGViiPKOV25sR2kSzujffUmO/B6EG/+2I8jku3HU=;
	b=rAIiSnmzKHnKmlEOjOADmAsWvbEZ+xYQZR7cE/4i91kHa/HStDxecZpanUvfHp2uJGM9vf
	K+NLo0fzH3jWbCjazTWTxrYKQdKrru1Ww9THb5y5jTsQC+aCDYtW4Xa9Ir/VBUTj4a7b1n
	NHZRoSnQ/EKv/0mAnxWy4clPt1m4s5o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
	maz@kernel.org, steven.price@arm.com, alexandru.elisei@arm.com,
	joey.gouly@arm.com, james.morse@arm.com,
	Jonathan.Cameron@huawei.com, dgilbert@redhat.com, jpb@kernel.org,
	oliver.upton@linux.dev, zhi.wang.linux@gmail.com,
	yuzenghui@huawei.com, salil.mehta@huawei.com,
	Andrew Jones <andrew.jones@linux.dev>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <ZZ4tsTQOKOamM+h/@vm3>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20231002124311.204614-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002124311.204614-1-suzuki.poulose@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 02, 2023 at 01:43:11PM +0100, Suzuki K Poulose wrote:
> Hi,
> 
> 
> > We are happy to announce the early RFC version of the Arm
> > Confidential Compute Architecture (CCA) support for the Linux
> > stack. The intention is to seek early feedback in the following areas:
> >  * KVM integration of the Arm CCA
> >  * KVM UABI for managing the Realms, seeking to generalise the operations
> >    wherever possible with other Confidential Compute solutions.
> >    Note: This version doesn't support Guest Private memory, which will be added
> >    later (see below).
> >  * Linux Guest support for Realms
> >
> 
> We have updated the stack for Arm CCA Linux support to RMM-v1.0-EAC2 (See links)
> We are not posting the patches for review yet, as we plan to update our
> stack to support the latest RMM-v1.0 specification, which includes some
> functional changes to support PSCI monitoring by the VMM along with other
> minor changes. All relevant components are updated on a new branch "rmm-v1.0-eac2"
> Guest-mem support is not included, but is in progress.
> 
> Change log :
>  - KVM RMI support updated to v1.0-eac2, with optimisations to stage2 tear down
>  - Guest (Linux and kvm-unit-test) support for RSI compliant to v1.0-eac2
>  - SVE, PMU support for Realms
> 
> kvmtool :
>   - Dropped no-compat and switched to --loglevel (merged upstream)
>   - Support for SVE, --sve-vl for vector length
> 
> > Arm CCA Introduction
> > =====================
> > 
> > The Arm CCA is a reference software architecture and implementation that builds
> > on the Realm Management Extension (RME), enabling the execution of Virtual
> > machines, while preventing access by more privileged software, such as hypervisor.
> > The Arm CCA allows the hypervisor to control the VM, but removes the right for
> > access to the code, register state or data that is used by VM.
> > More information on the architecture is available here[0].
> > 
> >     Arm CCA Reference Software Architecture
> > 
> >         Realm World    ||    Normal World   ||  Secure World  ||
> >                        ||        |          ||                ||
> >  EL0 x-------x         || x----x | x------x ||                ||
> >      | Realm |         || |    | | |      | ||                ||
> >      |       |         || | VM | | |      | ||                ||
> >  ----|  VM*  |---------||-|    |---|      |-||----------------||
> >      |       |         || |    | | |  H   | ||                ||
> >  EL1 x-------x         || x----x | |      | ||                ||
> >          ^             ||        | |  o   | ||                ||
> >          |             ||        | |      | ||                ||
> >  ------- R*------------------------|  s  -|---------------------
> >          S             ||          |      | ||                ||
> >          I             ||          |  t   | ||                ||
> >          |             ||          |      | ||                || 
> >          v             ||          x------x ||                ||
> >  EL2    RMM*           ||              ^    ||                ||
> >          ^             ||              |    ||                ||
> >  ========|=============================|========================
> >          |                             | SMC
> >          x--------- *RMI* -------------x
> > 
> >  EL3                   Root World
> >                        EL3 Firmware
> >  ===============================================================
> > Where :
> >  RMM - Realm Management Monitor
> >  RMI - Realm Management Interface
> >  RSI - Realm Service Interface
> >  SMC - Secure Monitor Call
> > 
> > RME introduces a new security state "Realm world", in addition to the
> > traditional Secure and Non-Secure states. The Arm CCA defines a new component,
> > Realm Management Monitor (RMM) that runs at R-EL2. This is a standard piece of
> > firmware, verified, installed and loaded by the EL3 firmware (e.g, TF-A), at
> > system boot.
> > 
> > The RMM provides standard interfaces - Realm Management Interface (RMI) - to the
> > Normal world hypervisor to manage the VMs running in the Realm world (also called
> > Realms in short). These are exposed via SMC and are routed through the EL3
> > firmwre.
> > The RMI interface includes:
> >   - Move a physical page from the Normal world to the Realm world
> >   - Creating a Realm with requested parameters, tracked via Realm Descriptor (RD)
> >   - Creating VCPUs aka Realm Execution Context (REC), with initial register state.
> >   - Create stage2 translation table at any level.
> >   - Load initial images into Realm Memory from normal world memory
> >   - Schedule RECs (vCPUs) and handle exits
> >   - Inject virtual interrupts into the Realm
> >   - Service stage2 runtime faults with pages (provided by host, scrubbed by RMM).
> >   - Create "shared" mappings that can be accessed by VMM/Hyp.
> >   - Reclaim the memory allocated for the RAM and RTTs (Realm Translation Tables)
> > 
> > However v1.0 of RMM specifications doesn't support:
> >  - Paging protected memory of a Realm VM. Thus the pages backing the protected
> >    memory region must be pinned.
> >  - Live migration of Realms.
> >  - Trusted Device assignment.
> >  - Physical interrupt backed Virtual interrupts for Realms
> > 
> > RMM also provides certain services to the Realms via SMC, called Realm Service
> > Interface (RSI). These include:
> >  - Realm Guest Configuration.
> >  - Attestation & Measurement services
> >  - Managing the state of an Intermediate Physical Address (IPA aka GPA) page.
> >  - Host Call service (Communication with the Normal world Hypervisor)
> > 
> > The specifications for the RMM software is currently at *v1.0-Beta2* and the
> > latest version is available here [1].
> > 
> > The Trusted Firmware foundation has an implementation of the RMM - TF-RMM -
> > available here [3].
> > 
> > Implementation
> > =================
> > 
> > This version of the stack is based on the RMM specification v1.0-Beta0[2], with
> > following exceptions :
> >   - TF-RMM/KVM currently doesn't support the optional features of PMU,
> >      SVE and Self-hosted debug (coming soon).
> >   - The RSI_HOST_CALL structure alignment requirement is reduced to match
> >      RMM v1.0 Beta1
> >   - RMI/RSI version numbers do not match the RMM spec. This will be
> >     resolved once the spec/implementation is complete, across TF-RMM+Linux stack.
> > 
> > We plan to update the stack to support the latest version of the RMMv1.0 spec
> > in the coming revisions.
> > 
> > This release includes the following components :
> > 
> >  a) Linux Kernel
> >      i) Host / KVM support - Support for driving the Realms via RMI. This is
> >      dependent on running in the Kernel at EL2 (aka VHE mode). Also provides
> >      UABI for VMMs to manage the Realm VMs. The support is restricted to 4K page
> >      size, matching the Stage2 granule supported by RMM. The VMM is responsible
> >      for making sure the guest memory is locked.
> > 
> >        TODO: Guest Private memory[10] integration - We have been following the
> >        series and support will be added once it is merged upstream.
> >      
> >      ii) Guest support - Support for a Linux Kernel to run in the Realm VM at
> >      Realm-EL1, using RSI services. This includes virtio support (virtio-v1.0
> >      only). All I/O are treated as non-secure/shared.
> >  
> >  c) kvmtool - VMM changes required to manage Realm VMs. No guest private memory
> >     as mentioned above.
> >  d) kvm-unit-tests - Support for running in Realms along with additional tests
> >     for RSI ABI.
> > 
> > Running the stack
> > ====================
> > 
> > To run/test the stack, you would need the following components :
> > 
> > 1) FVP Base AEM RevC model with FEAT_RME support [4]
> > 2) TF-A firmware for EL3 [5]
> > 3) TF-A RMM for R-EL2 [3]
> > 4) Linux Kernel [6]
> > 5) kvmtool [7]
> > 6) kvm-unit-tests [8]
> > 
> > Instructions for building the firmware components and running the model are
> > available here [9]. Once, the host kernel is booted, a Realm can be launched by
> > invoking the `lkvm` commad as follows:
> > 
> >  $ lkvm run --realm 				 \
> > 	 --measurement-algo=["sha256", "sha512"] \
> > 	 --disable-sve				 \
> 
> As noted above, this is no longer required.
> 
> > 	 <normal-vm-options>
> > 
> > Where:
> >  * --measurement-algo (Optional) specifies the algorithm selected for creating the
> >    initial measurements by the RMM for this Realm (defaults to sha256).
> >  * GICv3 is mandatory for the Realms.
> >  * SVE is not yet supported in the TF-RMM, and thus must be disabled using
> >    --disable-sve
> > 
> > You may also run the kvm-unit-tests inside the Realm world, using the similar
> > options as above.
> > 
> > 
> > Links
> > ============
> > 
> > [0] Arm CCA Landing page (See Key Resources section for various documentations)
> >     https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> > 
> > [1] RMM Specification Latest
> >     https://developer.arm.com/documentation/den0137/latest
> > 
> > [2] RMM v1.0-Beta0 specification
> >     https://developer.arm.com/documentation/den0137/1-0bet0/
> 
>  EAC2 spec: https://developer.arm.com/documentation/den0137/1-0eac2/
> > 
> > [3] Trusted Firmware RMM - TF-RMM
> >     https://www.trustedfirmware.org/projects/tf-rmm/
> >     GIT: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
> > 
> > [4] FVP Base RevC AEM Model (available on x86_64 / Arm64 Linux)
> >     https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms
> > 
> > [5] Trusted Firmware for A class
> >     https://www.trustedfirmware.org/projects/tf-a/
> > 
> > [6] Linux kernel support for Arm-CCA
> >     https://gitlab.arm.com/linux-arm/linux-cca
> >     Host Support branch:	cca-host/rfc-v1
> 
> Update branch : cca-host/rmm-v1.0-eac2
> 
> >     Guest Support branch:	cca-guest/rfc-v1
> 
> Update branch : cca-guest/rmm-v1.0-eac2
> 
> Combined tree for host and guest is also available at: "cca-full/rmm-v1.0-eac2"
> 
> > 
> > [7] kvmtool support for Arm CCA
> >     https://gitlab.arm.com/linux-arm/kvmtool-cca cca/rfc-v1
> 
> Update branch : cca/rmm-v1.0-eac2
> 
> > 
> > [8] kvm-unit-tests support for Arm CCA
> >     https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca  cca/rfc-v1
> > 
> 
> Update branch : cca/rmm-v1.0-eac2
> 
> 
> Suzuki
> 
> > [9] Instructions for Building Firmware components and running the model, see
> >     section 4.19.2 "Building and running TF-A with RME"
> >     https://trustedfirmware-a.readthedocs.io/en/latest/components/realm-management-extension.html#building-and-running-tf-a-with-rme
> > 
> > [10] fd based Guest Private memory for KVM
> >    https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng@linux.intel.com
> 
> 
> 
> 
> 
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Chao Peng <chao.p.peng@linux.intel.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joey Gouly <Joey.Gouly@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> To: linux-coco@lists.linux.dev
> To: kvmarm@lists.linux.dev
> Cc: linux-arm-kernel@lists.infradead.org
> To: linux-kernel@vger.kernel.org
> To: kvm@vger.kernel.org

Suzuki,
Any update to the Arm CCA series (v3?) since last October?

Thanks,
Itaru.

