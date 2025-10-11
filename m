Return-Path: <kvm+bounces-59803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 305F9BCFA37
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 19:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB68418937E0
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 17:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982E9283144;
	Sat, 11 Oct 2025 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="fXK3UTUf"
X-Original-To: kvm@vger.kernel.org
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253433D8;
	Sat, 11 Oct 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760203569; cv=none; b=fnti/Nsrfq+SwJRJgTBDlzfJ/7EmXx/JwZEIr5lmWWU4N2ZZ6opP5MxMjrQBagm1WwYRJRc9DaFcoB0aySmnW1+WtP1DDHRz70/d5dVzVXmC9QQcyZ8/SGx6x48FSk2oGxvDA/3H+AKvN7dE08lQr3noeyQEijHfgcFTjI/DswI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760203569; c=relaxed/simple;
	bh=MXz354onxhQhZwq2LfhNBXdWDHl+z85Ao+4shUSGRTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ih6DVJ/WkuIcgALGoZf38cblw3/UFFRUhJSvmmyyTjCztun1R/SxCPXvaSMlWDcjMyWlnlENPT+mab98DrVZj1V5LurswiTFRX5Y8AOsh9M/+5rmTTO+dE1zi2ER+OcUhpEBk9HYIlF1TUiWit0TjccwOVhY/aPrY+8MVnzCd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=fXK3UTUf; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=h4KeCDAUBdIaLG9b6hjFqL7CT3iy4tpp14+HLRyaEuM=; b=fXK3UTUfwEj5l/SFtZZ6Zhgdah
	LwYqFMfQjJQ16E8tvBHXYPDuKnnIjeimxL4RhXOe8UTfDrsAQfYW+SpmJ29O+rnzsvVmErzjdVsJB
	N5632vUPqv7MZVYuL81Cwhh1eSpNX1/bpXnInEac4xyHZ4fCXE5eiKzS1rWjrPKJBsog=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1v7dLv-00Ag51-LW; Sat, 11 Oct 2025 19:25:55 +0200
Date: Sat, 11 Oct 2025 19:25:55 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009093127-mutt-send-email-mst@kernel.org>

On Thu, Oct 09, 2025 at 09:37:20AM -0400, Michael S. Tsirkin wrote:
> On Thu, Oct 09, 2025 at 02:31:04PM +0200, Andrew Lunn wrote:
> > On Thu, Oct 09, 2025 at 07:24:08AM -0400, Michael S. Tsirkin wrote:
> > > A "word" is 16 bit. 64 bit integers like virtio uses are not dwords,
> > > they are actually qwords.
> > 
> > I'm having trouble with this....
> > 
> > This bit makes sense. 4x 16bits = 64 bits.
> > 
> > > -static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
> > > +static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
> > 
> > If this was u16, and VIRTIO_FEATURES_QWORDS was 4, which the Q would
> > imply, than i would agree with what you are saying. But this is a u64
> > type.  It is already a QWORD, and this is an array of two of them.
> 
> I don't get what you are saying here.
> It's an array of qwords and VIRTIO_FEATURES_QWORDS tells you
> how many QWORDS are needed to fit all of them.
> 
> This is how C arrays are declared.
> 
> 
> > I think the real issue here is not D vs Q, but WORD. We have a default
> > meaning of a u16 for a word, especially in C. But that is not the
> > actual definition of a word a computer scientist would use. Wikipedia
> > has:
> > 
> >   In computing, a word is any processor design's natural unit of
> >   data. A word is a fixed-sized datum handled as a unit by the
> >   instruction set or the hardware of the processor.
> > 
> > A word can be any size. In this context, virtio is not referring to
> > the instruction set, but a protocol. Are all fields in this protocol
> > u64? Hence word is u64? And this is an array of two words? That would
> > make DWORD correct, it is two words.
> > 
> > If you want to change anything here, i would actually change WORD to
> > something else, maybe FIELD?
> > 
> > And i could be wrong here, i've not looked at the actual protocol, so
> > i've no idea if all fields in the protocol are u64. There are
> > protocols like this, IPv6 uses u32, not octets, and the length field
> > in the headers refer to the number of u32s in the header.
> > 
> > 	Andrew
> 
> 
> Virtio uses "dword" to mean "32 bits" in several places:

It also uses WORD to represent 32 bits:

void
vp_modern_get_driver_extended_features(struct virtio_pci_modern_device *mdev,
				       u64 *features)
{
	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
	int i;

	virtio_features_zero(features);
	for (i = 0; i < VIRTIO_FEATURES_WORDS; i++) {
		u64 cur;

		vp_iowrite32(i, &cfg->guest_feature_select);
		cur = vp_ioread32(&cfg->guest_feature);
		features[i >> 1] |= cur << (32 * (i & 1));
	}
}

And this is a function dealing features. So this seems to suggest a
WORD is a u32, when dealing with features. A DWORD would thus be a
u64, making the current code correct.

As i said, the problem here is WORD. It means different things to
different people. And it even has different means to different parts
of the virtio code, as you pointed out.

If we want to change anything here, i suggest we change WORD to
something else, to try to avoid the problem that word could be a u16,
u32, or even a u42, depending on where it is used.

	Andrew

