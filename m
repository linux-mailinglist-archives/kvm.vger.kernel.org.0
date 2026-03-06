Return-Path: <kvm+bounces-73102-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UCBwH4gKq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73102-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:10:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 036D8225AD6
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 951FD3058578
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641054014B8;
	Fri,  6 Mar 2026 17:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csffKA2d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E543F23A6;
	Fri,  6 Mar 2026 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816965; cv=none; b=DnG+Y1j66zbaBti6sBojjSKJoFrNCeINC2m91x8vL40hX8rfJVe5IflkfO0BnT6irBABD2vu11TPVr29DnDkHw8xaG/PRFjosFy/vZSgeDZLb70MaOFGhhNW9BTMCDJETekCD6WPfPm++8w5g1gLmumv0cITUkKogV15YQdO+7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816965; c=relaxed/simple;
	bh=qlfiT1WvPHGKiAkw/yYFIMT7MN+ykNwQQeonFulb1DA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lJdzFWuIJ8piHZCvzPF22e753LurPjLkOEPFz+uB/CEH9jAULHG5MQK5Q5cVndjsD8dcy/Om6UpwW1DP33bi3HJ8vqzeJg8NWq1mvD4oQbT+qFP8/Xj8o3MUU5m6AjxNegtb2HUxY82/NYIcemkMTXNUXm8x1pAXu0YCyl0ZpD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csffKA2d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBEAC4CEF7;
	Fri,  6 Mar 2026 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816965;
	bh=qlfiT1WvPHGKiAkw/yYFIMT7MN+ykNwQQeonFulb1DA=;
	h=From:Subject:Date:To:Cc:From;
	b=csffKA2dejb3AqXeW6AXFdXdwJFyo1pCjBtthQpAias3MsenmgmbXWI7cr6mGZCJB
	 HiWTaq5NXvjQe6G9BjNx/I4oC1HVSgaupW9QAk2Pvak+omgl47RDETMxMyjfJ7OiSq
	 8JuJSP4o+jtHK7aa4G/BPEIlmgNbnY612avccsPfTh8zUylRSKlhtcA9zkWLU8KZN5
	 nG1UJCpnqmFO3/Vpw0Eai/jYRong52NJ3rHKLhlwdJko2RCsQz++MtnW3aikXyNqz2
	 vOwNj0GWVktJ+vbKB2hkzQMDhCIZ/kAdtQ0JcXYfWs91a1zci97LW9LPbOMSYwQimO
	 254EszEfCDA+A==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v10 00/30] KVM: arm64: Implement support for SME
Date: Fri, 06 Mar 2026 17:00:52 +0000
Message-Id: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEUIq2kC/2XSS07DMBAG4KtUWePKM353xT0QCz/bCJIUJ0Sgq
 nfHadRWxEuP/M3Yo//SjDG3cWwOu0uT49yO7dCXA9CXXeNPtj9G0oZSaJAio4wC+Zg7YnMnORm
 7SKi0gFwGJplsinF2jMRl2/vToqbuvFTPOab25zbm7b2cT+04Dfn3NnWGpbr2N4ib/jMQSlICH
 RR3aGJ4/Yi5j5/7IR+bpdWMDw5Ycyw8WETpHWjqXMXZnfPC6ZazwqlwFLSHlGLN+Z0LisC3nC/
 TJbdSgw3eY8XFk3NQWy6Wv3NpLAaRhOIVl08uUWy5LByA+5R4eTutuXpyXa9OFa6sFEGj0w5ox
 fWTG1pxXTh6h2CMl0L6ipsHL5tnW24K1y4yLZV3WrN//LpmKsev75LYaQ3Wmj0/dF07HXaz2lO
 SPZbL1z/8cf4D5gIAAA==
X-Change-ID: 20230301-kvm-arm64-sme-06a1246d3636
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=11293; i=broonie@kernel.org;
 h=from:subject:message-id; bh=qlfiT1WvPHGKiAkw/yYFIMT7MN+ykNwQQeonFulb1DA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwooUF7Yu8WMWLN7tprVS1RdZp5ntPCJVtscJ
 TDpKwvk2HOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKKAAKCRAk1otyXVSH
 0MnEB/0dRLkoHVpXj6bMY3UUriiz0lB5hmhgjaNEzlHNPfqrnm8QjV0Q3Ti2yC4GU0nUMS1WyM8
 Q6hYB76dKHo7atAUUS/KtIVwHUDE2Wcjuos5BtKE8NS9sEDsJ7IkokE4EJMcWThDqVNqexC0ViM
 DxyTJBuiMu0rEGqEje9DPUog92Ous81FLy8S3q5vsF9ZkTU6xtWV021vwTGzDQLpwiX9hGfQZt8
 ImqX6RnsD6DLDhWyO9rqWzD5ZDjKyNPF3GwsWVIIfgPm3nidQ5hlVLtp3/0VHyM9DXiLMaCQS/9
 LL2g2opztG76S61H1KHxvrD3ZRgfosPNEfToEuaFW7EfQC6w
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 036D8225AD6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73102-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.937];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

I've removed the RFC tag from this version of the series, but the items
that I'm looking for feedback on remains the same:

 - The userspace ABI, in particular:
  - The vector length used for the SVE registers, access to the SVE
    registers and access to ZA and (if available) ZT0 depending on
    the current state of PSTATE.{SM,ZA}.
  - The use of a single finalisation for both SVE and SME.

 - The addition of control for enabling fine grained traps in a similar
   manner to FGU but without the UNDEF, I'm not clear if this is desired
   at all and at present this requires symmetric read and write traps like
   FGU. That seemed like it might be desired from an implementation
   point of view but we already have one case where we enable an
   asymmetric trap (for ARM64_WORKAROUND_AMPERE_AC03_CPU_38) and it
   seems generally useful to enable asymmetrically.

This series implements support for SME use in non-protected KVM guests.
Much of this is very similar to SVE, the main additional challenge that
SME presents is that it introduces a new vector length similar to the
SVE vector length and two new controls which change the registers seen
by guests:

 - PSTATE.ZA enables the ZA matrix register and, if SME2 is supported,
   the ZT0 LUT register.
 - PSTATE.SM enables streaming mode, a new floating point mode which
   uses the SVE register set with the separately configured SME vector
   length.  In streaming mode implementation of the FFR register is
   optional.

It is also permitted to build systems which support SME without SVE, in
this case when not in streaming mode no SVE registers or instructions
are available.  Further, there is no requirement that there be any
overlap in the set of vector lengths supported by SVE and SME in a
system, this is expected to be a common situation in practical systems.

Since there is a new vector length to configure we introduce a new
feature parallel to the existing SVE one with a new pseudo register for
the streaming mode vector length.  Due to the overlap with SVE caused by
streaming mode rather than finalising SME as a separate feature we use
the existing SVE finalisation to also finalise SME, a new define
KVM_ARM_VCPU_VEC is provided to help make user code clearer.  Finalising
SVE and SME separately would introduce complication with register access
since finalising SVE makes the SVE registers writeable by userspace and
doing multiple finalisations results in an error being reported.
Dealing with a state where the SVE registers are writeable due to one of
SVE or SME being finalised but may have their VL changed by the other
being finalised seems like needless complexity with minimal practical
utility, it seems clearer to just express directly that only one
finalisation can be done in the ABI.

Access to the floating point registers follows the architecture:

 - When both SVE and SME are present:
   - If PSTATE.SM == 0 the vector length used for the Z and P registers
     is the SVE vector length.
   - If PSTATE.SM == 1 the vector length used for the Z and P registers
     is the SME vector length.
 - If only SME is present:
   - If PSTATE.SM == 0 the Z and P registers are inaccessible and the
     floating point state accessed via the encodings for the V registers.
   - If PSTATE.SM == 1 the vector length used for the Z and P registers
 - The SME specific ZA and ZT0 registers are only accessible if SVCR.ZA is 1.

The VMM must understand this, in particular when loading state SVCR
should be configured before other state.  It should be noted that while
the architecture refers to PSTATE.SM and PSTATE.ZA these PSTATE bits are
not preserved in SPSR_ELx, they are only accessible via SVCR.

There are a large number of subfeatures for SME, most of which only
offer additional instructions but some of which (SME2 and FA64) add
architectural state. These are configured via the ID registers as per
usual.

Protected KVM supported, with the implementation maintaining the
existing restriction that the hypervisor will refuse to run if streaming
mode or ZA is enabled.  This both simplfies the code and avoids the need
to allocate storage for host ZA and ZT0 state, there seems to be little
practical use case for supporting this and the memory usage would be
non-trivial.

The new KVM_ARM_VCPU_VEC feature and ZA and ZT0 registers have not been
added to the get-reg-list selftest, the idea of supporting additional
features there without restructuring the program to generate all
possible feature combinations has been rejected.  I will post a separate
series which does that restructuring.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v10:
- Define and use a SME_VQ_INVALID for the case where there is no
  virtuablisable SME VL.
- Fix handling of SMCR_EL2 accesses.
- Correct VNCR constant for SMPRI_EL2.
- Correct trapping for SMPRI_EL1.
- Reject userspace access to FFR when in streaming mode without FA64.
- Constrain the VL set by sme_cond_update_smcr() to fit within LEN.
- Reject userspace access to ZA and ZT0 when SVCR.SM is 0.
- Use -EACCESS for inaccessible SME registers.
- Remove some unused functions.
- Further bugfixes from review.
- Commit log typo fixes.

- Link to v9: https://patch.msgid.link/20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org

Changes in v9:
- Rebase onto v6.19-rc1.
- ABI document clarifications.
- Add changes dropping asserts on single bit wide bitfields in set_id_regs.
- Link to v8: https://lore.kernel.org/r/20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org

Changes in v8:
- Small fixes in ABI documentation.
- Link to v7: https://lore.kernel.org/r/20250822-kvm-arm64-sme-v7-0-7a65d82b8b10@kernel.org

Changes in v7:
- Rebase onto v6.17-rc1.
- Handle SMIDR_EL1 as a VM wide ID register and use this in feat_sme_smps().
- Expose affinity fields in SMIDR_EL1.
- Remove SMPRI_EL1 from vcpu_sysreg, the value is always 0 currently.
- Prevent userspace writes to SMPRIMAP_EL2.
- Link to v6: https://lore.kernel.org/r/20250625-kvm-arm64-sme-v6-0-114cff4ffe04@kernel.org

Changes in v6:
- Rebase onto v6.16-rc3.
- Link to v5: https://lore.kernel.org/r/20250417-kvm-arm64-sme-v5-0-f469a2d5f574@kernel.org

Changes in v5:
- Rebase onto v6.15-rc2.
- Add pKVM guest support.
- Always restore SVCR.
- Link to v4: https://lore.kernel.org/r/20250214-kvm-arm64-sme-v4-0-d64a681adcc2@kernel.org

Changes in v4:
- Rebase onto v6.14-rc2 and Mark Rutland's fixes.
- Expose SME to nested guests.
- Additional cleanups and test fixes following on from the rebase.
- Flush register state on VMM PSTATE.{SM,ZA}.
- Link to v3: https://lore.kernel.org/r/20241220-kvm-arm64-sme-v3-0-05b018c1ffeb@kernel.org

Changes in v3:
- Rebase onto v6.12-rc2.
- Link to v2: https://lore.kernel.org/r/20231222-kvm-arm64-sme-v2-0-da226cb180bb@kernel.org

Changes in v2:
- Rebase onto v6.7-rc3.
- Configure subfeatures based on host system only.
- Complete nVHE support.
- There was some snafu with sending v1 out, it didn't make it to the
  lists but in case it hit people's inboxes I'm sending as v2.

---
Mark Brown (30):
      arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
      arm64/fpsimd: Update FA64 and ZT0 enables when loading SME state
      arm64/fpsimd: Decide to save ZT0 and streaming mode FFR at bind time
      arm64/fpsimd: Determine maximum virtualisable SME vector length
      KVM: arm64: Pay attention to FFR parameter in SVE save and load
      KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
      KVM: arm64: Move SVE state access macros after feature test macros
      KVM: arm64: Rename SVE finalization constants to be more general
      KVM: arm64: Define internal features for SME
      KVM: arm64: Rename sve_state_reg_region
      KVM: arm64: Store vector lengths in an array
      KVM: arm64: Factor SVE code out of fpsimd_lazy_switch_to_host()
      KVM: arm64: Document the KVM ABI for SME
      KVM: arm64: Implement SME vector length configuration
      KVM: arm64: Support SME control registers
      KVM: arm64: Support TPIDR2_EL0
      KVM: arm64: Support SME identification registers for guests
      KVM: arm64: Support SME priority registers
      KVM: arm64: Provide assembly for SME register access
      KVM: arm64: Support userspace access to streaming mode Z and P registers
      KVM: arm64: Flush register state on writes to SVCR.SM and SVCR.ZA
      KVM: arm64: Expose SME specific state to userspace
      KVM: arm64: Context switch SME state for guests
      KVM: arm64: Handle SME exceptions
      KVM: arm64: Expose SME to nested guests
      KVM: arm64: Provide interface for configuring and enabling SME for guests
      KVM: arm64: selftests: Remove spurious check for single bit safe values
      KVM: arm64: selftests: Skip impossible invalid value tests
      KVM: arm64: selftests: Add SME system registers to get-reg-list
      KVM: arm64: selftests: Add SME to set_id_regs test

 Documentation/virt/kvm/api.rst                   | 124 ++++++---
 arch/arm64/include/asm/fpsimd.h                  |  34 ++-
 arch/arm64/include/asm/kvm_emulate.h             |  14 +
 arch/arm64/include/asm/kvm_host.h                | 170 +++++++++---
 arch/arm64/include/asm/kvm_hyp.h                 |   4 +-
 arch/arm64/include/asm/kvm_pkvm.h                |   2 +-
 arch/arm64/include/asm/sysreg.h                  |   2 +
 arch/arm64/include/asm/vncr_mapping.h            |   2 +
 arch/arm64/include/uapi/asm/kvm.h                |  36 +++
 arch/arm64/kernel/cpufeature.c                   |   2 -
 arch/arm64/kernel/fpsimd.c                       |  78 +++---
 arch/arm64/kvm/arm.c                             |  10 +
 arch/arm64/kvm/config.c                          |   8 +-
 arch/arm64/kvm/fpsimd.c                          |  28 +-
 arch/arm64/kvm/guest.c                           | 332 ++++++++++++++++++++---
 arch/arm64/kvm/handle_exit.c                     |  14 +
 arch/arm64/kvm/hyp/fpsimd.S                      |  25 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h          | 218 ++++++++++++---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h       |  99 ++++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c               | 111 ++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c                   |  88 ++++--
 arch/arm64/kvm/hyp/nvhe/switch.c                 |   2 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c               |   6 +
 arch/arm64/kvm/hyp/vhe/switch.c                  |  17 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c               |   7 +
 arch/arm64/kvm/nested.c                          |   3 +-
 arch/arm64/kvm/reset.c                           | 156 ++++++++---
 arch/arm64/kvm/sys_regs.c                        | 167 +++++++++++-
 arch/arm64/tools/sysreg                          |   8 +-
 include/uapi/linux/kvm.h                         |   1 +
 tools/testing/selftests/kvm/arm64/get-reg-list.c |  15 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c  |  95 ++++++-
 32 files changed, 1532 insertions(+), 346 deletions(-)
---
base-commit: 9fad1d148df6f36105159c2503d0ecb1397bc89a
change-id: 20230301-kvm-arm64-sme-06a1246d3636

Best regards,
--  
Mark Brown <broonie@kernel.org>


