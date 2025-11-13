Return-Path: <kvm+bounces-63016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6033C57FFA
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A274420914
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 14:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E280D2C326F;
	Thu, 13 Nov 2025 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rnhIROL7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E32C11F0;
	Thu, 13 Nov 2025 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763044389; cv=none; b=Ae4TZVUUo6t5lrIIRTIJ8gbzSpaiY4GolNcnjPorrLj8Ne/2YdhiLqsGcNc03vIkQjB18DcSjQIopg0djeWzXG6DFgSKrm5ZUIqeu45umQz6nLdpqDYLoh81YuD+bZuLyiByN++bKAtMMaMN+wa2KfLjR4w+SFCrO9ine2CIXSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763044389; c=relaxed/simple;
	bh=ebSWHDsZiGuR5Nbtgt0yHWL36FZHHBG1Uy8JrxeZPIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7n7d5dhOzp6SbOoIPAJmm6RVB+QMn8wL1mk0ZCXZaldIrsFKjXgcfktdPHGyDsmCDLv/W87agSI5NPZN5bOHnorchGB2Y19BtS5XVPpcjgFPMUWF97/XSGB+VL7QVtgPJz2/9jOSVoNJkSpt8zmET4VKf9fV7uft12wspaGzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rnhIROL7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB4C4CEF7;
	Thu, 13 Nov 2025 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763044388;
	bh=ebSWHDsZiGuR5Nbtgt0yHWL36FZHHBG1Uy8JrxeZPIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnhIROL72Cjh4Q0Rld0GoDFTYMasXbcHcIhh5RbFJOsBC8YFlUiuGtUT8AdfNqLnt
	 kizUBaaXLptjL/Hx3u0zAWy/8QJBE7Rhaj9LkouMEayq2AmWakIF3wZEk18ZwI60Wx
	 QpN28r3xzrm90El96bH99ezUfSdGHn5VNCp3ADZbGvEDT2AEwIOAU8TqzNjT5eDeoN
	 Jh5UI/Zjsu/y57rXsavECsxMlbpVXEy310O69N6KonsG903EEx0oBoat48N1x0wLlK
	 6TO6VwPdeL7MZhxH4fYHORg+2MTtfMHPEzcrqbRx6N5VwuSyKqmHvRrnIe6kH6s8Th
	 DuAO6jrv+LjSg==
Date: Thu, 13 Nov 2025 14:33:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 05/45] KVM: arm64: GICv3: Detect and work around the
 lack of ICV_DIR_EL1 trapping
Message-ID: <7ae5874e-366f-4abd-9142-ffbe21fed3a8@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ndg81+8i7Uvtbel"
Content-Disposition: inline
In-Reply-To: <20251109171619.1507205-6-maz@kernel.org>
X-Cookie: Live Free or Live in Massachusetts.


--3ndg81+8i7Uvtbel
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2025 at 05:15:39PM +0000, Marc Zyngier wrote:
> A long time ago, an unsuspecting architect forgot to add a trap
> bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
> what's a bit of spec between friends? Thankfully, this was fixed
> in a later revision, and ARM "deprecates" the lack of trapping
> ability.

I'm seeing a regression on i.MX8MP-EVK and Toradax AM625+Mallow boards
(both 4xA53+GICv3) in protected mode only with a bunch of the KVM
selftests, including the arch_timer one:

# selftests: kvm: arch_timer
# Random seed: 0x6b8b4567
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:487: false
#   pid=3D4469 tid=3D4473 errno=3D4 - Interrupted system call
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:487: false
#   pid=3D4469 tid=3D4471 errno=3D4 - Interrupted system call
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:487: false
#   pid=3D4469 tid=3D4472 errno=3D4 - Interrupted system call
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:487: false
#   pid=3D4469 tid=3D4470 errno=3D4 - Interrupted system call
#      1	0x0000000000414387: assert_on_unhandled_exception at processor.c:4=
87
#      2	0x000000000040727f: _vcpu_run at kvm_util.c:1699
#      3	 (inlined by) vcpu_run at kvm_util.c:1710
#      4	0x0000000000402b07: test_vcpu_run at arch_timer.c:55
#      5	0x0000ffffb12f2f9b: ?? ??:0
#      6	0x0000ffffb135e58b: ?? ??:0
#      1	0x0000000000414387: assert_on_unhandled_exception at processor.c:4=
87
#      2	0x000000000040727f: _vcpu_run at kvm_util.c:1699
#      3	 (inlined by) vcpu_run at kvm_util.c:1710
#      4	0x0000000000402b07: test_vcpu_run at arch_timer.c:55
#      5	0x0000ffffb12f2f9b: ?? ??:0
#      6	0x0000ffffb135e58b: ?? ??:0
#   Unexpected exception (vector:0x4, ec:0x0)
#      1	0x0000000000414387: assert_on_unhandled_exception at processor.c:4=
87
#      2	0x000000000040727f: _vcpu_run at kvm_util.c:1699
#      3	 (inlined by) vcpu_run at kvm_util.c:1710
#      4	0x0000000000402b07: test_vcpu_run at arch_timer.c:55
#      5	0x0000ffffb12f2f9b: ?? ??:0
#      6	0x0000ffffb135e58b: ?? ??:0
#      1	0x0000000000414387: assert_on_unhandled_exception at processor.c:4=
87
#      2	0x000000000040727f: _vcpu_run at kvm_util.c:1699
#      3	 (inlined by) vcpu_run at kvm_util.c:1710
#      4	0x0000000000402b07: test_vcpu_run at arch_timer.c:55
#      5	0x0000ffffb12f2f9b: ?? ??:0
#      6	0x0000ffffb135e58b: ?? ??:0
not ok 28 selftests: kvm: arch_timer # exit=3D254

The arch_timer case bisects to this patch in -next, regular nVHE mode
runs this test happily.  Full log (on the i.MX8MP-EVK):

   https://lava.sirena.org.uk/scheduler/job/2079917#L3993

bisect log:

# bad: [6d7e7251d03f98f26f2ee0dfd21bb0a0480a2178] Add linux-next specific f=
iles for 20251113
# good: [aeee991e3a4cb03497cda0f879619c2e71143b49] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [4d6e2211aeb932e096f673c88475016b1cc0f8ab] ASoC: Intel: boards: fix=
 HDMI playback lookup when HDMI-In capture used
# good: [1d562ba0aa7df81335bf96c02be77efe8d5bab87] spi: dt-bindings: nuvoto=
n,npcm-pspi: Convert to DT schema
# good: [b3a5302484033331af37569f7277d00131694b57] ASoC: Intel: sof_rt5682:=
 Add quirk override support
# good: [32172cf3cb543a04c41a1677c97a38e60cad05b6] ASoC: cs35l56: Allow res=
toring factory calibration through ALSA control
# good: [873bc94689d832878befbcadc10b6ad5bb4e0027] ASoC: Intel: sof_sdw: ad=
d codec speaker support for the SKU
# good: [772ada50282b0c80343c8989147db816961f571d] ASoC: cs35l56: Alter err=
or codes for calibration routine
# good: [6985defd1d832f1dd9d1977a6a2cc2cef7632704] regmap: sdw-mbq: Reorder=
 regmap_mbq_context struct for better packing
# good: [fb1ebb10468da414d57153ddebaab29c38ef1a78] regulator: core: disable=
 supply if enabling main regulator fails
# good: [2089f086303b773e181567fd8d5df3038bd85937] regulator: mt6363: Remov=
e unneeded semicolon
# good: [4e92abd0a11b91af3742197a9ca962c3c00d0948] spi: imx: add i.MX51 ECS=
PI target mode support
# good: [6951be397ca8b8b167c9f99b5a11c541148c38cb] ASoC: codecs: pm4125: re=
move duplicate code
# good: [abc9a349b87ac0fd3ba8787ca00971b59c2e1257] spi: fsl-qspi: support t=
he SpacemiT K1 SoC
# good: [1b0f3f9ee41ee2bdd206667f85ea2aa36dfe6e69] ASoC: SDCA: support Q7.8=
 volume format
# good: [6bd1ad97eb790570c167d4de4ca59fbc9c33722a] regulator: pf9453: Fix k=
ernel doc for mux_poll()
# good: [55d03b5b5bdd04daf9a35ce49db18d8bb488dffb] spi: imx: remove CLK cal=
culation and check for target mode
# good: [655079ac8a7721ac215a0596e3f33b740e01144a] ASoC: qcom: q6asm: Use g=
uard() for spin locks
# good: [3c36965df80801344850388592e95033eceea05b] regulator: Add support f=
or MediaTek MT6363 SPMI PMIC Regulators
# good: [2f538ef9f6f7c3d700c68536f21447dfc598f8c8] spi: aspeed: Use devm_io=
unmap() to unmap devm_ioremap() memory
# good: [aa897ffc396b48cc39eee133b6b43175d0df9eb5] ASoC: dt-bindings: ti,pc=
m1862: convert to dtschema
# good: [c4e68959af66df525d71db619ffe44af9178bb22] ASoC: dt-bindings: ti,ta=
s2781: Add TAS5822 support
# good: [af9c8092d84244ca54ffb590435735f788e7a170] regmap: i3c: Use ARRAY_S=
IZE()
# good: [380fd29d57abe6679d87ec56babe65ddc5873a37] spi: tegra210-quad: Chec=
k hardware status on timeout
# good: [84194c66aaf78fed150edb217b9f341518b1cba2] ASoC: codecs: aw88261: p=
ass pointer directly instead of passing the address
# good: [252abf2d07d33b1c70a59ba1c9395ba42bbd793e] regulator: Small cleanup=
 in of_get_regulation_constraints()
# good: [2ecc8c089802e033d2e5204d21a9f467e2517df9] regulator: pf9453: remov=
e unused I2C_LT register
# good: [ed5d499b5c9cc11dd3edae1a7a55db7dfa4f1bdc] regcache: maple: Split -=
>populate() from ->init()
# good: [e73b743bfe8a6ff4e05b5657d3f7586a17ac3ba0] ASoC: soc-core: check op=
s & auto_selectable_formats in snd_soc_dai_get_fmt() to prevent dereference=
 error
# good: [f1dfbc1b5cf8650ae9a0d543e5f5335fc0f478ce] ASoC: max98090/91: fixin=
g the stream index
# good: [6ef8e042cdcaabe3e3c68592ba8bfbaee2fa10a3] ASoC: codec: wm8400: rep=
lace printk() calls with dev_*() device aware logging
# good: [ecd0de438c1f0ee86cf8f6d5047965a2a181444b] spi: tle62x0: Add newlin=
e to sysfs attribute output
# good: [20bcda681f8597e86070a4b3b12d1e4f541865d3] ASoC: codecs: va-macro: =
fix revision checking
# good: [8fdb030fe283c84fd8d378c97ad0f32d6cdec6ce] ASoC: qcom: sc7280: make=
 use of common helpers
# good: [e062bdfdd6adbb2dee7751d054c1d8df63ddb8b8] regmap: warn users about=
 uninitialized flat cache
# good: [28039efa4d8e8bbf98b066133a906bd4e307d496] MAINTAINERS: remove obso=
lete file entry in DIALOG SEMICONDUCTOR DRIVERS
# good: [cf6bf51b53252284bafc7377a4d8dbf10f048b4d] ASoC: cs4271: Add suppor=
t for the external mclk
# good: [66fecfa91deb536a12ddf3d878a99590d7900277] ASoC: spacemit: use `dep=
ends on` instead of `select`
# good: [f034c16a4663eaf3198dc18b201ba50533fb5b81] ASoC: spacemit: add fail=
ure check for spacemit_i2s_init_dai()
# good: [4a5ac6cd05a7e54f1585d7779464d6ed6272c134] ASoC: sun4i-spdif: Suppo=
rt SPDIF output on A523 family
# good: [4c33cef58965eb655a0ac8e243aa323581ec025f] regulator: pca9450: link=
 regulator inputs to supply groups
# good: [4795375d8aa072e9aacb0b278e6203c6ca41816a] ASoC: cs-amp-lib-test: A=
dd test cases for cs_amp_set_efi_calibration_data()
# good: [ef042df96d0e1089764f39ede61bc8f140a4be00] ASoC: SDCA: Add HID butt=
on IRQ
# good: [77a58ba7c64ccca20616aa03599766ccb0d1a330] spi: spi-mem: Trace exec=
_op
# good: [01313661b248c5ba586acae09bff57077dbec0a5] regulator: Let raspberry=
pi drivers depend on ARM
# good: [e973dfe9259095fb509ab12658c68d46f0e439d7] ASoC: qcom: sm8250: add =
qrb2210-sndcard compatible string
# good: [e7434adf0c53a84d548226304cdb41c8818da1cb] ASoC: cs530x: Add SPI bu=
s support for cs530x parts
# good: [d29479abaded34b2b1dab2e17efe96a65eba3d61] ASoC: renesas: fsi: Cons=
tify struct fsi_stream_handler
# good: [c17fa4cbc546c431ccf13e9354d5d9c1cd247b7c] ASoC: sdw_utils: add nam=
e_prefix for rt1321 part id
# good: [2528c15f314ece50218d1273654f630d74109583] ASoC: max98090/91: addin=
g DAPM routing for digital output for max98091
# good: [fd5ef3d69f8975bad16c437a337b5cb04c8217a2] spi: spi-qpic-snand: mak=
e qcom_spi_ecc_engine_ops_pipelined const
# good: [310bf433c01f78e0756fd5056a43118a2f77318c] ASoC: max98090/91: fixin=
g a space
# good: [d054cc3a2ccfb19484f3b54d69b6e416832dc8f4] regulator: rpmh-regulato=
r: Add RPMH regulator support for PMR735D
# good: [638bae3fb225a708dc67db613af62f6d14c4eff4] ASoC: max98090/91: added=
 DAPM widget for digital output for max98091
# good: [ecba655bf54a661ffe078856cd8dbc898270e4b5] ASoC: fsl_aud2htx: add I=
EC958_SUBFRAME_LE format in supported list
# good: [7e1906643a7374529af74b013bba35e4fa4e6ffc] ASoC: codecs: va-macro: =
Clean up on error path in probe()
# good: [d742ebcfe524dc54023f7c520d2ed2e4b7203c19] ASoC: soc.h: remove snd_=
soc_kcontrol_component()
# good: [fce217449075d59b29052b8cdac567f0f3e22641] ASoC: spacemit: add i2s =
support for K1 SoC
# good: [6658472a3e2de08197acfe099ba71ee0e2505ecf] ASoC: amd: amd_sdw: Prop=
agate the PCI subsystem Vendor and Device IDs
# good: [0cc08c8130ac8f74419f99fe707dc193b7f79d86] spi: aspeed: Fix an IS_E=
RR() vs NULL bug in probe()
# good: [0743acf746a81e0460a56fd5ff847d97fa7eb370] spi: airoha: buffer must=
 be 0xff-ed before writing
# good: [79eaabc61dfbf5a4b680f42d3a113d05333c3960] irqchip/riscv-imsic: Emb=
ed the vector array in lpriv
# good: [00a155c691befdb10bea52c91d4c8c930bdaf73a] Merge branch 'objtool/co=
re' of https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux
# good: [1e570e77392f43a3cdab2849d1f81535f8a033e2] ASoC: mxs-saif: support =
usage with simple-audio-card
# good: [d77daa49085b067137d0adbe3263f75a7ee13a1b] spi: aspeed: fix spellin=
g mistake "triming" -> "trimming"
# good: [15afe57a874eaf104bfbb61ec598fa31627f7b19] ASoC: dt-bindings: qcom:=
 Add Kaanapali LPASS macro codecs
# good: [65efe5404d151767653c7b7dd39bd2e7ad532c2d] regulator: rpmh-regulato=
r: Add RPMH regulator support for Glymur
# good: [fb25114cd760c13cf177d9ac37837fafcc9657b5] regulator: sy7636a: add =
gpios and input regulator
# good: [6621b0f118d500092f5f3d72ddddb22aeeb3c3a0] ASoC: codecs: rt5670: us=
e SOC_VALUE_ENUM_SINGLE_DECL for DAC2 L/R MX-1B
# good: [50062baa536bcac03804cf04579c71b9351e829c] perf print-events: Remov=
e print_symbol_events
# good: [433e294c3c5b5d2020085a0e36c1cb47b694690a] regulator: core: forward=
 undervoltage events downstream by default
# good: [0b0eb7702a9fa410755e86124b4b7cd36e7d1cb4] ASoC: replace use of sys=
tem_wq with system_dfl_wq
# good: [c2d420796a427dda71a2400909864e7f8e037fd4] elfnote: Change ELFNOTE(=
) to use __UNIQUE_ID()
# good: [3049fc4b5f1d2320a84e2902b3ac5a735f60ca04] x86/alternative: Refacto=
r INT3 call emulation selftest
# good: [07e1c3fd86d7a2ddce3ebc6b7390590c8524a484] objtool: Make find_symbo=
l_containing() less arbitrary
# good: [9f14f1f91883aa2bfd6663161d2002c8ce937c43] compiler.h: Make address=
able symbols less of an eyesore
# good: [6717e8f91db71641cb52855ed14c7900972ed0bc] kbuild: Remove 'kmod_' p=
refix from __KBUILD_MODNAME
# good: [4109043bff31f95d3da9ace33eb3c1925fd62cbd] modpost: Ignore unresolv=
ed section bounds symbols
# good: [a1526bcfcb6cb7cb601b9ff8e24d08881ef9afb8] objtool: Mark prefix fun=
ctions
# good: [122679ebf90eeff97c5f793ed9a289197e0fbb2c] x86/kprobes: Remove STAC=
K_FRAME_NON_STANDARD annotation
# good: [7e7e2c6e2a1cb250f8d03bb99eed01f6d982d5dd] ASoC: sof-function-topol=
ogy-lib: escalate the log when missing function topoplogy
# good: [4d410ba9aa275e7990a270f63ce436990ace1bea] dt-bindings: sound: Upda=
te ADMAIF bindings for tegra264
# good: [fe8cc44dd173cde5788ab4e3730ac61f3d316d9c] spi: dw: add target mode=
 support
# good: [9797329220a2c6622411eb9ecf6a35b24ce09d04] ASoC: sof-function-topol=
ogy-lib: escalate the log when missing function topoplogy
# good: [5e537031f322d55315cd384398b726a9a0748d47] ASoC: codecs: Fix the er=
ror of excessive semicolons
# good: [4412ab501677606436e5c49e41151a1e6eac7ac0] spi: dt-bindings: spi-qp=
ic-snand: Add IPQ5332 compatible
# good: [64d87ccfae3326a9561fe41dc6073064a083e0df] spi: aspeed: Only map ne=
cessary address window region
# good: [b83fb1b14c06bdd765903ac852ba20a14e24f227] spi: offload: Add offset=
 parameter
# good: [6277a486a7faaa6c87f4bf1d59a2de233a093248] regulator: dt-bindings: =
Convert Dialog DA9211 Regulators to DT schema
# good: [a3a8c9c18f6904a777ff21f300d3da8c2b214c80] usb: vhci-hcd: Replace p=
r_*() with dev_*() logging
# good: [561f0ed96a626c53fbd9a06ce2de6349fd0c31d2] staging: rtl8723bs: sdio=
: clarify OQT free page comment
# good: [fe3a615dadd398f73cde00a5ba32389958242dec] drm/xe/vf: Kickstart aft=
er resfix in VF post migration recovery
# good: [59fedf46f782c024b74ceab7868e13f0e0f10c45] drm/ast: Split ast_detec=
t_tx_chip() per chip generation
git bisect start '6d7e7251d03f98f26f2ee0dfd21bb0a0480a2178' 'aeee991e3a4cb0=
3497cda0f879619c2e71143b49' '4d6e2211aeb932e096f673c88475016b1cc0f8ab' '1d5=
62ba0aa7df81335bf96c02be77efe8d5bab87' 'b3a5302484033331af37569f7277d001316=
94b57' '32172cf3cb543a04c41a1677c97a38e60cad05b6' '873bc94689d832878befbcad=
c10b6ad5bb4e0027' '772ada50282b0c80343c8989147db816961f571d' '6985defd1d832=
f1dd9d1977a6a2cc2cef7632704' 'fb1ebb10468da414d57153ddebaab29c38ef1a78' '20=
89f086303b773e181567fd8d5df3038bd85937' '4e92abd0a11b91af3742197a9ca962c3c0=
0d0948' '6951be397ca8b8b167c9f99b5a11c541148c38cb' 'abc9a349b87ac0fd3ba8787=
ca00971b59c2e1257' '1b0f3f9ee41ee2bdd206667f85ea2aa36dfe6e69' '6bd1ad97eb79=
0570c167d4de4ca59fbc9c33722a' '55d03b5b5bdd04daf9a35ce49db18d8bb488dffb' '6=
55079ac8a7721ac215a0596e3f33b740e01144a' '3c36965df80801344850388592e95033e=
ceea05b' '2f538ef9f6f7c3d700c68536f21447dfc598f8c8' 'aa897ffc396b48cc39eee1=
33b6b43175d0df9eb5' 'c4e68959af66df525d71db619ffe44af9178bb22' 'af9c8092d84=
244ca54ffb590435735f788e7a170' '380fd29d57abe6679d87ec56babe65ddc5873a37' '=
84194c66aaf78fed150edb217b9f341518b1cba2' '252abf2d07d33b1c70a59ba1c9395ba4=
2bbd793e' '2ecc8c089802e033d2e5204d21a9f467e2517df9' 'ed5d499b5c9cc11dd3eda=
e1a7a55db7dfa4f1bdc' 'e73b743bfe8a6ff4e05b5657d3f7586a17ac3ba0' 'f1dfbc1b5c=
f8650ae9a0d543e5f5335fc0f478ce' '6ef8e042cdcaabe3e3c68592ba8bfbaee2fa10a3' =
'ecd0de438c1f0ee86cf8f6d5047965a2a181444b' '20bcda681f8597e86070a4b3b12d1e4=
f541865d3' '8fdb030fe283c84fd8d378c97ad0f32d6cdec6ce' 'e062bdfdd6adbb2dee77=
51d054c1d8df63ddb8b8' '28039efa4d8e8bbf98b066133a906bd4e307d496' 'cf6bf51b5=
3252284bafc7377a4d8dbf10f048b4d' '66fecfa91deb536a12ddf3d878a99590d7900277'=
 'f034c16a4663eaf3198dc18b201ba50533fb5b81' '4a5ac6cd05a7e54f1585d7779464d6=
ed6272c134' '4c33cef58965eb655a0ac8e243aa323581ec025f' '4795375d8aa072e9aac=
b0b278e6203c6ca41816a' 'ef042df96d0e1089764f39ede61bc8f140a4be00' '77a58ba7=
c64ccca20616aa03599766ccb0d1a330' '01313661b248c5ba586acae09bff57077dbec0a5=
' 'e973dfe9259095fb509ab12658c68d46f0e439d7' 'e7434adf0c53a84d548226304cdb4=
1c8818da1cb' 'd29479abaded34b2b1dab2e17efe96a65eba3d61' 'c17fa4cbc546c431cc=
f13e9354d5d9c1cd247b7c' '2528c15f314ece50218d1273654f630d74109583' 'fd5ef3d=
69f8975bad16c437a337b5cb04c8217a2' '310bf433c01f78e0756fd5056a43118a2f77318=
c' 'd054cc3a2ccfb19484f3b54d69b6e416832dc8f4' '638bae3fb225a708dc67db613af6=
2f6d14c4eff4' 'ecba655bf54a661ffe078856cd8dbc898270e4b5' '7e1906643a7374529=
af74b013bba35e4fa4e6ffc' 'd742ebcfe524dc54023f7c520d2ed2e4b7203c19' 'fce217=
449075d59b29052b8cdac567f0f3e22641' '6658472a3e2de08197acfe099ba71ee0e2505e=
cf' '0cc08c8130ac8f74419f99fe707dc193b7f79d86' '0743acf746a81e0460a56fd5ff8=
47d97fa7eb370' '79eaabc61dfbf5a4b680f42d3a113d05333c3960' '00a155c691befdb1=
0bea52c91d4c8c930bdaf73a' '1e570e77392f43a3cdab2849d1f81535f8a033e2' 'd77da=
a49085b067137d0adbe3263f75a7ee13a1b' '15afe57a874eaf104bfbb61ec598fa31627f7=
b19' '65efe5404d151767653c7b7dd39bd2e7ad532c2d' 'fb25114cd760c13cf177d9ac37=
837fafcc9657b5' '6621b0f118d500092f5f3d72ddddb22aeeb3c3a0' '50062baa536bcac=
03804cf04579c71b9351e829c' '433e294c3c5b5d2020085a0e36c1cb47b694690a' '0b0e=
b7702a9fa410755e86124b4b7cd36e7d1cb4' 'c2d420796a427dda71a2400909864e7f8e03=
7fd4' '3049fc4b5f1d2320a84e2902b3ac5a735f60ca04' '07e1c3fd86d7a2ddce3ebc6b7=
390590c8524a484' '9f14f1f91883aa2bfd6663161d2002c8ce937c43' '6717e8f91db716=
41cb52855ed14c7900972ed0bc' '4109043bff31f95d3da9ace33eb3c1925fd62cbd' 'a15=
26bcfcb6cb7cb601b9ff8e24d08881ef9afb8' '122679ebf90eeff97c5f793ed9a289197e0=
fbb2c' '7e7e2c6e2a1cb250f8d03bb99eed01f6d982d5dd' '4d410ba9aa275e7990a270f6=
3ce436990ace1bea' 'fe8cc44dd173cde5788ab4e3730ac61f3d316d9c' '9797329220a2c=
6622411eb9ecf6a35b24ce09d04' '5e537031f322d55315cd384398b726a9a0748d47' '44=
12ab501677606436e5c49e41151a1e6eac7ac0' '64d87ccfae3326a9561fe41dc6073064a0=
83e0df' 'b83fb1b14c06bdd765903ac852ba20a14e24f227' '6277a486a7faaa6c87f4bf1=
d59a2de233a093248' 'a3a8c9c18f6904a777ff21f300d3da8c2b214c80' '561f0ed96a62=
6c53fbd9a06ce2de6349fd0c31d2' 'fe3a615dadd398f73cde00a5ba32389958242dec' '5=
9fedf46f782c024b74ceab7868e13f0e0f10c45'
# test job: [4d6e2211aeb932e096f673c88475016b1cc0f8ab] https://lava.sirena.=
org.uk/scheduler/job/2078045
# test job: [1d562ba0aa7df81335bf96c02be77efe8d5bab87] https://lava.sirena.=
org.uk/scheduler/job/2078452
# test job: [b3a5302484033331af37569f7277d00131694b57] https://lava.sirena.=
org.uk/scheduler/job/2074506
# test job: [32172cf3cb543a04c41a1677c97a38e60cad05b6] https://lava.sirena.=
org.uk/scheduler/job/2075063
# test job: [873bc94689d832878befbcadc10b6ad5bb4e0027] https://lava.sirena.=
org.uk/scheduler/job/2074989
# test job: [772ada50282b0c80343c8989147db816961f571d] https://lava.sirena.=
org.uk/scheduler/job/2069151
# test job: [6985defd1d832f1dd9d1977a6a2cc2cef7632704] https://lava.sirena.=
org.uk/scheduler/job/2059206
# test job: [fb1ebb10468da414d57153ddebaab29c38ef1a78] https://lava.sirena.=
org.uk/scheduler/job/2059735
# test job: [2089f086303b773e181567fd8d5df3038bd85937] https://lava.sirena.=
org.uk/scheduler/job/2058045
# test job: [4e92abd0a11b91af3742197a9ca962c3c00d0948] https://lava.sirena.=
org.uk/scheduler/job/2055814
# test job: [6951be397ca8b8b167c9f99b5a11c541148c38cb] https://lava.sirena.=
org.uk/scheduler/job/2056393
# test job: [abc9a349b87ac0fd3ba8787ca00971b59c2e1257] https://lava.sirena.=
org.uk/scheduler/job/2054629
# test job: [1b0f3f9ee41ee2bdd206667f85ea2aa36dfe6e69] https://lava.sirena.=
org.uk/scheduler/job/2053476
# test job: [6bd1ad97eb790570c167d4de4ca59fbc9c33722a] https://lava.sirena.=
org.uk/scheduler/job/2053930
# test job: [55d03b5b5bdd04daf9a35ce49db18d8bb488dffb] https://lava.sirena.=
org.uk/scheduler/job/2054195
# test job: [655079ac8a7721ac215a0596e3f33b740e01144a] https://lava.sirena.=
org.uk/scheduler/job/2049656
# test job: [3c36965df80801344850388592e95033eceea05b] https://lava.sirena.=
org.uk/scheduler/job/2050587
# test job: [2f538ef9f6f7c3d700c68536f21447dfc598f8c8] https://lava.sirena.=
org.uk/scheduler/job/2048586
# test job: [aa897ffc396b48cc39eee133b6b43175d0df9eb5] https://lava.sirena.=
org.uk/scheduler/job/2048671
# test job: [c4e68959af66df525d71db619ffe44af9178bb22] https://lava.sirena.=
org.uk/scheduler/job/2044470
# test job: [af9c8092d84244ca54ffb590435735f788e7a170] https://lava.sirena.=
org.uk/scheduler/job/2043681
# test job: [380fd29d57abe6679d87ec56babe65ddc5873a37] https://lava.sirena.=
org.uk/scheduler/job/2044549
# test job: [84194c66aaf78fed150edb217b9f341518b1cba2] https://lava.sirena.=
org.uk/scheduler/job/2038332
# test job: [252abf2d07d33b1c70a59ba1c9395ba42bbd793e] https://lava.sirena.=
org.uk/scheduler/job/2038504
# test job: [2ecc8c089802e033d2e5204d21a9f467e2517df9] https://lava.sirena.=
org.uk/scheduler/job/2038909
# test job: [ed5d499b5c9cc11dd3edae1a7a55db7dfa4f1bdc] https://lava.sirena.=
org.uk/scheduler/job/2029006
# test job: [e73b743bfe8a6ff4e05b5657d3f7586a17ac3ba0] https://lava.sirena.=
org.uk/scheduler/job/2026401
# test job: [f1dfbc1b5cf8650ae9a0d543e5f5335fc0f478ce] https://lava.sirena.=
org.uk/scheduler/job/2025480
# test job: [6ef8e042cdcaabe3e3c68592ba8bfbaee2fa10a3] https://lava.sirena.=
org.uk/scheduler/job/2025879
# test job: [ecd0de438c1f0ee86cf8f6d5047965a2a181444b] https://lava.sirena.=
org.uk/scheduler/job/2026088
# test job: [20bcda681f8597e86070a4b3b12d1e4f541865d3] https://lava.sirena.=
org.uk/scheduler/job/2022933
# test job: [8fdb030fe283c84fd8d378c97ad0f32d6cdec6ce] https://lava.sirena.=
org.uk/scheduler/job/2021446
# test job: [e062bdfdd6adbb2dee7751d054c1d8df63ddb8b8] https://lava.sirena.=
org.uk/scheduler/job/2020179
# test job: [28039efa4d8e8bbf98b066133a906bd4e307d496] https://lava.sirena.=
org.uk/scheduler/job/2020283
# test job: [cf6bf51b53252284bafc7377a4d8dbf10f048b4d] https://lava.sirena.=
org.uk/scheduler/job/2022983
# test job: [66fecfa91deb536a12ddf3d878a99590d7900277] https://lava.sirena.=
org.uk/scheduler/job/2015329
# test job: [f034c16a4663eaf3198dc18b201ba50533fb5b81] https://lava.sirena.=
org.uk/scheduler/job/2015473
# test job: [4a5ac6cd05a7e54f1585d7779464d6ed6272c134] https://lava.sirena.=
org.uk/scheduler/job/2011241
# test job: [4c33cef58965eb655a0ac8e243aa323581ec025f] https://lava.sirena.=
org.uk/scheduler/job/2010807
# test job: [4795375d8aa072e9aacb0b278e6203c6ca41816a] https://lava.sirena.=
org.uk/scheduler/job/2011005
# test job: [ef042df96d0e1089764f39ede61bc8f140a4be00] https://lava.sirena.=
org.uk/scheduler/job/2011039
# test job: [77a58ba7c64ccca20616aa03599766ccb0d1a330] https://lava.sirena.=
org.uk/scheduler/job/2007290
# test job: [01313661b248c5ba586acae09bff57077dbec0a5] https://lava.sirena.=
org.uk/scheduler/job/2008742
# test job: [e973dfe9259095fb509ab12658c68d46f0e439d7] https://lava.sirena.=
org.uk/scheduler/job/2012324
# test job: [e7434adf0c53a84d548226304cdb41c8818da1cb] https://lava.sirena.=
org.uk/scheduler/job/2007744
# test job: [d29479abaded34b2b1dab2e17efe96a65eba3d61] https://lava.sirena.=
org.uk/scheduler/job/2008412
# test job: [c17fa4cbc546c431ccf13e9354d5d9c1cd247b7c] https://lava.sirena.=
org.uk/scheduler/job/2000004
# test job: [2528c15f314ece50218d1273654f630d74109583] https://lava.sirena.=
org.uk/scheduler/job/1997593
# test job: [fd5ef3d69f8975bad16c437a337b5cb04c8217a2] https://lava.sirena.=
org.uk/scheduler/job/1996100
# test job: [310bf433c01f78e0756fd5056a43118a2f77318c] https://lava.sirena.=
org.uk/scheduler/job/1996021
# test job: [d054cc3a2ccfb19484f3b54d69b6e416832dc8f4] https://lava.sirena.=
org.uk/scheduler/job/1995684
# test job: [638bae3fb225a708dc67db613af62f6d14c4eff4] https://lava.sirena.=
org.uk/scheduler/job/1991853
# test job: [ecba655bf54a661ffe078856cd8dbc898270e4b5] https://lava.sirena.=
org.uk/scheduler/job/1985116
# test job: [7e1906643a7374529af74b013bba35e4fa4e6ffc] https://lava.sirena.=
org.uk/scheduler/job/1978575
# test job: [d742ebcfe524dc54023f7c520d2ed2e4b7203c19] https://lava.sirena.=
org.uk/scheduler/job/1976775
# test job: [fce217449075d59b29052b8cdac567f0f3e22641] https://lava.sirena.=
org.uk/scheduler/job/1975621
# test job: [6658472a3e2de08197acfe099ba71ee0e2505ecf] https://lava.sirena.=
org.uk/scheduler/job/1976196
# test job: [0cc08c8130ac8f74419f99fe707dc193b7f79d86] https://lava.sirena.=
org.uk/scheduler/job/1965692
# test job: [0743acf746a81e0460a56fd5ff847d97fa7eb370] https://lava.sirena.=
org.uk/scheduler/job/1964813
# test job: [79eaabc61dfbf5a4b680f42d3a113d05333c3960] https://lava.sirena.=
org.uk/scheduler/job/1979980
# test job: [00a155c691befdb10bea52c91d4c8c930bdaf73a] https://lava.sirena.=
org.uk/scheduler/job/1980696
# test job: [1e570e77392f43a3cdab2849d1f81535f8a033e2] https://lava.sirena.=
org.uk/scheduler/job/1963814
# test job: [d77daa49085b067137d0adbe3263f75a7ee13a1b] https://lava.sirena.=
org.uk/scheduler/job/1964718
# test job: [15afe57a874eaf104bfbb61ec598fa31627f7b19] https://lava.sirena.=
org.uk/scheduler/job/1963938
# test job: [65efe5404d151767653c7b7dd39bd2e7ad532c2d] https://lava.sirena.=
org.uk/scheduler/job/1962057
# test job: [fb25114cd760c13cf177d9ac37837fafcc9657b5] https://lava.sirena.=
org.uk/scheduler/job/1963349
# test job: [6621b0f118d500092f5f3d72ddddb22aeeb3c3a0] https://lava.sirena.=
org.uk/scheduler/job/1962085
# test job: [50062baa536bcac03804cf04579c71b9351e829c] https://lava.sirena.=
org.uk/scheduler/job/1978269
# test job: [433e294c3c5b5d2020085a0e36c1cb47b694690a] https://lava.sirena.=
org.uk/scheduler/job/1957339
# test job: [0b0eb7702a9fa410755e86124b4b7cd36e7d1cb4] https://lava.sirena.=
org.uk/scheduler/job/1957395
# test job: [c2d420796a427dda71a2400909864e7f8e037fd4] https://lava.sirena.=
org.uk/scheduler/job/1981809
# test job: [3049fc4b5f1d2320a84e2902b3ac5a735f60ca04] https://lava.sirena.=
org.uk/scheduler/job/1989503
# test job: [07e1c3fd86d7a2ddce3ebc6b7390590c8524a484] https://lava.sirena.=
org.uk/scheduler/job/1980837
# test job: [9f14f1f91883aa2bfd6663161d2002c8ce937c43] https://lava.sirena.=
org.uk/scheduler/job/1981518
# test job: [6717e8f91db71641cb52855ed14c7900972ed0bc] https://lava.sirena.=
org.uk/scheduler/job/1981667
# test job: [4109043bff31f95d3da9ace33eb3c1925fd62cbd] https://lava.sirena.=
org.uk/scheduler/job/1981316
# test job: [a1526bcfcb6cb7cb601b9ff8e24d08881ef9afb8] https://lava.sirena.=
org.uk/scheduler/job/1980768
# test job: [122679ebf90eeff97c5f793ed9a289197e0fbb2c] https://lava.sirena.=
org.uk/scheduler/job/1981229
# test job: [7e7e2c6e2a1cb250f8d03bb99eed01f6d982d5dd] https://lava.sirena.=
org.uk/scheduler/job/1954246
# test job: [4d410ba9aa275e7990a270f63ce436990ace1bea] https://lava.sirena.=
org.uk/scheduler/job/1947847
# test job: [fe8cc44dd173cde5788ab4e3730ac61f3d316d9c] https://lava.sirena.=
org.uk/scheduler/job/1947074
# test job: [9797329220a2c6622411eb9ecf6a35b24ce09d04] https://lava.sirena.=
org.uk/scheduler/job/1947363
# test job: [5e537031f322d55315cd384398b726a9a0748d47] https://lava.sirena.=
org.uk/scheduler/job/1946632
# test job: [4412ab501677606436e5c49e41151a1e6eac7ac0] https://lava.sirena.=
org.uk/scheduler/job/1946228
# test job: [64d87ccfae3326a9561fe41dc6073064a083e0df] https://lava.sirena.=
org.uk/scheduler/job/1953764
# test job: [b83fb1b14c06bdd765903ac852ba20a14e24f227] https://lava.sirena.=
org.uk/scheduler/job/1946821
# test job: [6277a486a7faaa6c87f4bf1d59a2de233a093248] https://lava.sirena.=
org.uk/scheduler/job/1953762
# test job: [a3a8c9c18f6904a777ff21f300d3da8c2b214c80] https://lava.sirena.=
org.uk/scheduler/job/1979592
# test job: [561f0ed96a626c53fbd9a06ce2de6349fd0c31d2] https://lava.sirena.=
org.uk/scheduler/job/1978456
# test job: [fe3a615dadd398f73cde00a5ba32389958242dec] https://lava.sirena.=
org.uk/scheduler/job/1978703
# test job: [59fedf46f782c024b74ceab7868e13f0e0f10c45] https://lava.sirena.=
org.uk/scheduler/job/1979218
# test job: [6d7e7251d03f98f26f2ee0dfd21bb0a0480a2178] https://lava.sirena.=
org.uk/scheduler/job/2079917
# bad: [6d7e7251d03f98f26f2ee0dfd21bb0a0480a2178] Add linux-next specific f=
iles for 20251113
git bisect bad 6d7e7251d03f98f26f2ee0dfd21bb0a0480a2178
# test job: [3d08639208ff9f52d988c95781bc45d41d94ffd0] https://lava.sirena.=
org.uk/scheduler/job/2080233
# good: [3d08639208ff9f52d988c95781bc45d41d94ffd0] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
git bisect good 3d08639208ff9f52d988c95781bc45d41d94ffd0
# test job: [f7bef466d6ea35a35e9c852a7b5315ce969c7877] https://lava.sirena.=
org.uk/scheduler/job/2080382
# good: [f7bef466d6ea35a35e9c852a7b5315ce969c7877] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/libata/linux
git bisect good f7bef466d6ea35a35e9c852a7b5315ce969c7877
# test job: [362f39fb330b5578824bd5330403d6c438582483] https://lava.sirena.=
org.uk/scheduler/job/2080519
# bad: [362f39fb330b5578824bd5330403d6c438582483] Merge branch 'driver-core=
-next' of https://git.kernel.org/pub/scm/linux/kernel/git/driver-core/drive=
r-core.git
git bisect bad 362f39fb330b5578824bd5330403d6c438582483
# test job: [f6e1d0d9e619027062eed9217d4804c11044a27a] https://lava.sirena.=
org.uk/scheduler/job/2080640
# good: [f6e1d0d9e619027062eed9217d4804c11044a27a] Merge branch 'master' of=
 https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git bisect good f6e1d0d9e619027062eed9217d4804c11044a27a
# test job: [44d048590effc717acf997ff9b7545193289fbf0] https://lava.sirena.=
org.uk/scheduler/job/2080756
# bad: [44d048590effc717acf997ff9b7545193289fbf0] Merge branch 'next' of ht=
tps://github.com/kvm-x86/linux.git
git bisect bad 44d048590effc717acf997ff9b7545193289fbf0
# test job: [b50267d5e8901940dfb948ad8d36628e8392c5dc] https://lava.sirena.=
org.uk/scheduler/job/2080827
# good: [b50267d5e8901940dfb948ad8d36628e8392c5dc] Merge branch 'non-rcu/ne=
xt' of https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good b50267d5e8901940dfb948ad8d36628e8392c5dc
# test job: [5acf839dcad8bdfc6d646c34680c008bd1167cde] https://lava.sirena.=
org.uk/scheduler/job/2080878
# good: [5acf839dcad8bdfc6d646c34680c008bd1167cde] Merge branch 'tdx'
git bisect good 5acf839dcad8bdfc6d646c34680c008bd1167cde
# test job: [182853c7680aaaf00fffd7cd347ae4aa50805fdf] https://lava.sirena.=
org.uk/scheduler/job/2080989
# bad: [182853c7680aaaf00fffd7cd347ae4aa50805fdf] KVM: arm64: GICv2: Handle=
 deactivation via GICV_DIR traps
git bisect bad 182853c7680aaaf00fffd7cd347ae4aa50805fdf
# test job: [d78124a65a03f1483c62d8612594d5d833b8e4a5] https://lava.sirena.=
org.uk/scheduler/job/2081054
# bad: [d78124a65a03f1483c62d8612594d5d833b8e4a5] KVM: arm64: GICv2: Extrac=
t LR computing primitive
git bisect bad d78124a65a03f1483c62d8612594d5d833b8e4a5
# test job: [2a69aca33cac6b191fd13c7ea16c33df680a1b0e] https://lava.sirena.=
org.uk/scheduler/job/2081151
# bad: [2a69aca33cac6b191fd13c7ea16c33df680a1b0e] KVM: arm64: Add LR overfl=
ow handling documentation
git bisect bad 2a69aca33cac6b191fd13c7ea16c33df680a1b0e
# test job: [ca30799f7c2d04400a428fbc82aa49dc2493cc1a] https://lava.sirena.=
org.uk/scheduler/job/2081229
# good: [ca30799f7c2d04400a428fbc82aa49dc2493cc1a] KVM: arm64: Turn vgic-v3=
 errata traps into a patched-in constant
git bisect good ca30799f7c2d04400a428fbc82aa49dc2493cc1a
# test job: [10576b2d86522cc70d8e1d8e121a2cb9c44c2ff3] https://lava.sirena.=
org.uk/scheduler/job/2081295
# bad: [10576b2d86522cc70d8e1d8e121a2cb9c44c2ff3] KVM: arm64: Repack struct=
 vgic_irq fields
git bisect bad 10576b2d86522cc70d8e1d8e121a2cb9c44c2ff3
# test job: [375e16720b4c8ee04a01de03fb7103ac0a7a4856] https://lava.sirena.=
org.uk/scheduler/job/2081327
# bad: [375e16720b4c8ee04a01de03fb7103ac0a7a4856] KVM: arm64: GICv3: Detect=
 and work around the lack of ICV_DIR_EL1 trapping
git bisect bad 375e16720b4c8ee04a01de03fb7103ac0a7a4856
# first bad commit: [375e16720b4c8ee04a01de03fb7103ac0a7a4856] KVM: arm64: =
GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping

--3ndg81+8i7Uvtbel
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkV7B0ACgkQJNaLcl1U
h9Anxgf/YRiggfdxUKVJvAFd6EBlw9W6Oo4UmBTgK0zmUmkkQpcRJlk2Mj+bqhkp
ULqAs6FOzYDrfn156LzVMfya+CbZqkg/FfdUEXgxW5bNybz3ZxGtm+ZStE0b0Ifh
wzIrjJ7tc0faOg7VV3a4JRgba4nLBQncNukPLrmtexHCoeJ2t1ZbTQViM/g0GNoT
KBL+6QZuulmlG6y1asr/usIeNIlsqHJDW2Qm/zgNOyWBb1eFp8ybu1WegHAWOp1F
+8HcU6iTRmOXB+fSPBMJLuvo4WptnWFQX5KWwL0tRW7FPRlygCGv2OFeFtl/ZZ0H
cA8UF54/ZNl0yII5vyocZZO0XTTWwA==
=vu5/
-----END PGP SIGNATURE-----

--3ndg81+8i7Uvtbel--

